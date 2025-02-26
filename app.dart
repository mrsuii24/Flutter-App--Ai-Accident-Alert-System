import 'dart:typed_data';
import 'package:accident_detection_app/apis/auth_api.dart';
import 'package:accident_detection_app/screens/history_screen.dart';
import 'package:accident_detection_app/screens/signin_screen.dart';
import 'package:accident_detection_app/screens/signup_screen.dart';
import 'package:accident_detection_app/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:fftea/fftea.dart';
import 'screens/about_screen.dart';
import 'screens/chat_bot.dart';
import 'screens/data_center_screen.dart';
import 'screens/em_contact_screen.dart';
import 'screens/faq_screen.dart';
import 'screens/help_center_screen.dart';
import 'screens/help_screen.dart';
import 'screens/notification_screen.dart';
import 'screens/service_screen.dart';
import 'screens/settings_screen.dart';
import 'widget/bottom_navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:math';
import './classifier/classifier.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  List<double> accelerationXBuffer = [];
  List<double> accelerationYBuffer = [];
  List<double> accelerationZBuffer = [];
  final int bufferSize = 256;
  final _classifier = Classifier();
  FFT? _fft;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _fft = FFT(256);
    _getStatus().then((status) {
      if (status == 'Active') {
        accelerometerEvents.listen((AccelerometerEvent event) {
          _checkFallDetection(event);
          _updateAccelerometerData(event);
        });
      }
    });
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
  }

  Future<String> _getStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isServiceActive = prefs.getBool('isServiceActive');
    final service = isServiceActive == true ? 'Active' : 'Inactive';
    return service;
  }

  void _initializeNotifications() {
    try {
      const initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid);
      _flutterLocalNotificationsPlugin.initialize(initializationSettings);
    } catch (e) {
      debugPrint('$e');
    }
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return position;
  }

  void _updateAccelerometerData(AccelerometerEvent event) {
    accelerationXBuffer.add(event.x);
    accelerationYBuffer.add(event.y);
    accelerationZBuffer.add(event.z);

    if (accelerationXBuffer.length > bufferSize) {
      accelerationXBuffer.removeAt(0);
      accelerationYBuffer.removeAt(0);
      accelerationZBuffer.removeAt(0);
    }

    if (accelerationXBuffer.length == bufferSize) {
      _performFFT(
          accelerationXBuffer, accelerationYBuffer, accelerationZBuffer);
    }
  }

  void _performFFT(List<double> accelerometerXData,
      List<double> accelerometerYData, List<double> accelerometerZData) {
    final xData = List<double>.from(accelerometerXData);
    final yData = List<double>.from(accelerometerYData);
    final zData = List<double>.from(accelerometerZData);
    final xFreq = _fft?.realFft(xData) ?? Float64x2List(0);
    final yFreq = _fft?.realFft(yData) ?? Float64x2List(0);
    final zFreq = _fft?.realFft(zData) ?? Float64x2List(0);
    final xMagnitudes = xFreq.map<double>((e) {
      return sqrt(e.x * e.x + e.y * e.y);
    }).toList();
    final yMagnitudes = yFreq.map<double>((e) {
      return sqrt(e.x * e.x + e.y * e.y);
    }).toList();
    final zMagnitudes = zFreq.map<double>((e) {
      return sqrt(e.x * e.x + e.y * e.y);
    }).toList();
  }

  void _checkFallDetection(AccelerometerEvent event) async {
    try {
      final totalAcceleration =
          (event.x * event.x + event.y * event.y + event.z * event.z);
      final finalAcceleration = sqrt(totalAcceleration);
      const fallThreshold = 30.0;
      if (finalAcceleration > fallThreshold) {
        final accX = event.x;
        final accY = event.y;
        final accZ = event.z;

        // Determine the orientation of the device
        final orientation = _calculateOrientation(accX, accY, accZ);

        // Update the acceleration buffers
        accelerationXBuffer.add(accX);
        accelerationYBuffer.add(accY);
        accelerationZBuffer.add(accZ);

        if (accelerationXBuffer.length > bufferSize) {
          accelerationXBuffer.removeAt(0);
          accelerationYBuffer.removeAt(0);
          accelerationZBuffer.removeAt(0);
        }

        if (accelerationXBuffer.length == bufferSize) {
          // Perform FFT for the current buffer
          final accFFTX = _calculateFFTMagnitude(accelerationXBuffer);
          final accFFTY = _calculateFFTMagnitude(accelerationYBuffer);
          final accFFTZ = _calculateFFTMagnitude(accelerationZBuffer);

          // Prepare the feature list
          final features = [
            orientation,
            accX,
            accY,
            accZ,
            accFFTX,
            accFFTY,
            accFFTZ
          ];
          final featureList = Float32List.fromList(features);
          _classifier.predict(featureList).then((prediction) async {
            debugPrint(prediction);
            if (prediction == 'runFall' ||
                prediction == 'freeFall' ||
                prediction == 'walkFall') {
              try {
                Position position = await _getCurrentLocation();
                List<Placemark> placemarks = await placemarkFromCoordinates(
                    position.latitude, position.longitude);
                String address = "";
                if (placemarks.isNotEmpty) {
                  Placemark placemark = placemarks.first;
                  String? locality = placemark.locality;
                  if (locality != null) address += "$locality, ${position.latitude}, ${position.longitude}";
                }
                _sendFallNotification();
                final currentUser = await AuthAPI().readCurrentUser();
                final emContacts = currentUser!.emContact;       
                final DateTime now = DateTime.now();
                final String dateTimeString =
                    "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} "
                    "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
                final updatedUser = currentUser.copyWith(
                  history: List<String>.from(currentUser.history)
                    ..add(dateTimeString),
                );
                await AuthAPI().addAlerts(address);
                await AuthAPI().updateUser(updatedUser);
                if (emContacts.isNotEmpty) {
                  List<String> emailList = emContacts.values.toList();
                  await AuthAPI().sendEmailAlerts(emailList, address, dateTimeString, currentUser.name);
                }
              } catch (error) {
                debugPrint("Error fetching current user: $error");
              }
            }
          }).catchError((error) {
            debugPrint("Error during prediction: $error");
          });
        } else {
          debugPrint('${accelerationXBuffer.length}');
        }
      }
    } catch (e) {
      debugPrint('Error in fall detection: $e');
    }
  }

// Function to calculate orientation based on acceleration values
  double _calculateOrientation(double x, double y, double z) {
    // Simplified orientation calculation based on the device's tilt
    final pitch = atan2(y, sqrt(x * x + z * z)) * 180 / pi;
    final roll = atan2(x, sqrt(y * y + z * z)) * 180 / pi;

    // Normalize and combine orientation into a single value (customizable)
    return sqrt(pitch * pitch + roll * roll);
  }

// Function to calculate the magnitude of the FFT result
  double _calculateFFTMagnitude(List<double> data) {
    final freqData = _fft?.realFft(data) ?? Float64x2List(0);
    final magnitudes = freqData.map<double>((e) => sqrt(e.x * e.x + e.y * e.y));
    return magnitudes.reduce((a, b) => a + b) /
        magnitudes.length; // Average magnitude
  }

  void _sendFallNotification() async {
    try {
      const androidDetails = AndroidNotificationDetails(
        'fall_detection_channel',
        'Fall Detection Notifications',
        channelDescription: 'Channel for fall detection alerts.',
        importance: Importance.high,
        priority: Priority.high,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
      );

      await _flutterLocalNotificationsPlugin.show(
        0,
        'Fall Detected!',
        'The phone has detected a fall. Please check.',
        notificationDetails,
      );
    } catch (e) {
      debugPrint('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    return MaterialApp(
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: _user != null ? const BottomNavBar() : const WelcomeScreen(),
      routes: {
        '/landing': (context) =>
            _user != null ? const BottomNavBar() : const WelcomeScreen(),
        '/home': (context) => const BottomNavBar(),
        '/signin': (context) =>
            _user != null ? const BottomNavBar() : const SignInScreen(),
        '/signup': (context) =>
            _user != null ? const BottomNavBar() : const SignUpScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/notify': (context) => const NotificationScreen(),
        '/panel1': (context) => const DataCenterScreen(),
        '/panel2': (context) => const EmergencyContactScreen(),
        '/panel3': (context) => const Chatbot(),
        '/panel4': (context) => const SettingsScreen(),
        '/panel5': (context) => const HelpCenterScreen(),
        '/panel6': (context) => const ServiceScreen(),
        '/help': (context) => const HelpScreen(),
        '/about': (context) => const AboutPage(),
        '/faq': (context) => const FAQPage(),
        '/history': (context) => const FallDetectionHistoryScreen(),
      },
    );
  }
}
