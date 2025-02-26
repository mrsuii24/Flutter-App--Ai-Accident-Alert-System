import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), () {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: const Duration(seconds: 10 * 10), curve: Curves.linear);
    });

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Help & Feedback',
          style: TextStyle(
              fontWeight: FontWeight.w900, fontSize: 16, color: Colors.white),
        ),
        backgroundColor: Colors.black.withOpacity(0.9),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: Colors.grey[800],
        child: ListView.builder(
          controller: scrollController,
          itemCount: 1,
          itemBuilder: (context, index) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                '''The Accident Detection Project aims to develop a mobile application capable of detecting falls by analyzing sensor data from the device’s accelerometer and gyroscope. Upon detecting a fall, the app automatically alerts an emergency contact via email and a centralized web platform. The email alert includes essential details such as the user’s current location, IP address, and other relevant data to facilitate a swift response from emergency services. This project leverages machine learning, specifically a pre-trained TensorFlow model, to predict falls based on real-time sensor readings. By integrating GPS, accelerometer, gyroscope, and machine learning, the system creates an effective solution for fall detection. The architecture of the system is comprised of multiple components that collectively enable fall detection and alerting, with a clear workflow that ensures efficiency in emergency situations.

The core components of the system include the mobile app, TensorFlow model, email service, and notification handler. The mobile app is responsible for monitoring the accelerometer and gyroscope data, detecting falls, and triggering alerts. The TensorFlow model processes the sensor data and predicts whether a fall has occurred. If a fall is detected, the app immediately sends an email alert to the emergency contact, containing the user’s location and details. Additionally, the app sends a notification to a centralized web platform, which stores the user’s information, such as location and IP address. The web platform then triggers immediate action, such as notifying emergency services, ensuring a rapid response.

The TensorFlow model is a crucial part of the system, as it is responsible for accurately predicting falls based on sensor data. The model is pre-trained and loaded into the mobile app, which uses it to process data from the accelerometer and gyroscope sensors. When a fall is detected, the app triggers the “sendEmail” and “sendNotification” methods. The email contains the user’s current location and is sent to a preconfigured emergency contact. Simultaneously, the app sends a notification to the centralized platform with the user’s location, IP address, and other pertinent details. This dual alert system ensures that multiple channels of communication are used to reach emergency responders or family members.

The web platform plays a vital role in the architecture, receiving alerts and storing user data, including the user’s location and IP address. The platform can trigger the “Act immediately” function to ensure a swift and appropriate response, such as notifying authorities or emergency services. The platform provides centralized management of alerts, enabling emergency services to respond quickly to accidents and falls.

In conclusion, the Accident Detection Project is a comprehensive system that effectively integrates real-time sensor data analysis, machine learning, and communication features. It ensures timely assistance for individuals who have fallen, by alerting both emergency contacts and centralized platforms. The system is designed to be reliable, efficient, and capable of saving lives by providing rapid alerts in the event of a fall. Through the combination of mobile technology, machine learning, and real-time communication, this project aims to make a significant impact in emergency response and personal safety. The system’s robust architecture, seamless integration, and workflow ensure that help is always within reach, providing peace of mind for individuals who are at risk of accidents and falls.''',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  height: 1.5,
                ),
                textAlign: TextAlign.justify,
              ),
            );
          },
        ),
      ),
    );
  }
}
