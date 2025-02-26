import 'package:accident_detection_app/model/user_model.dart';
import 'package:accident_detection_app/widget/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:accident_detection_app/apis/auth_api.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  void _signUpWithGoogle(BuildContext context) async {
    try {
      final authAPI = AuthAPI();
      final userCredential = await authAPI.googleSignin();
      if (userCredential != null) {
        debugPrint('Google Sign-Up successful');
        final loggedUser = await authAPI.readCurrentUser();
        if (loggedUser == null) {
          final Map<String, String> emContact = {};
          final userData = UserModel(
              uid: userCredential.user?.uid ?? '',
              name: '',
              address: '',
              age: 18,
              altPhoneNumber: '',
              emContact: emContact,
              email: userCredential.user?.email ?? '',
              helpCenter: '',
              location: '',
              phoneNumber: '',
              history: []);

          await authAPI.createUser(userData);
        }
        Navigator.of(context).pushReplacement<void, void>(MaterialPageRoute(
          builder: (BuildContext context) {
            return const BottomNavBar();
          },
        ));
      } else {
        debugPrint('Google Sign-Up Failed');
      }
    } catch (e) {
      debugPrint('error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/bg2.png',
            fit: BoxFit.cover,
          ),
          Column(
            children: [
              const Spacer(),
              Center(
                child: ElevatedButton.icon(
                  icon: SvgPicture.asset(
                    'assets/images/google.svg',
                    width: 24,
                    height: 24,
                  ),
                  label: const Text("Sign up with Google"),
                  onPressed: () {
                    _signUpWithGoogle(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.8),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/signin');
                  },
                  child: const Text(
                    "Already have an account? Sign in",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
