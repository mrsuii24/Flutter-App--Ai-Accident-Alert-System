import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Accident Detection Project',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Introduction',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 5),
              Text(
                '''The Accident Detection project aims to create a mobile application that can detect falls using sensor data (accelerometer and gyroscope) and a pre-trained TensorFlow model. Upon detecting a fall, the app sends alerts to both an emergency contact via email and a centralized web platform. The alert contains the user\'s current location, IP address, and other pertinent details to ensure timely assistance.''',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 20),
              Text(
                'System Architecture Overview',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 5),
              Text(
                '''The architecture of the Accident Detection system is composed of several components, each with specific responsibilities. These components work together to detect falls and send alerts. The architecture is illustrated in the provided diagram.''',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 20),
              Text(
                'Key Components',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 5),
              Text(
                '1. Mobile App:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 5),
              Text(
                '''• Sensors: Accelerometer and Gyroscope for detecting motion and orientation.\n• TensorFlowModel: Pre-trained model used to predict falls.\n• GPS: Retrieves the user’s location.\n• EmailService: Sends alerts to emergency contacts.\n• NotificationHandler: Sends alerts to a centralized platform.''',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 20),
              Text(
                '2. TensorFlowModel:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 5),
              Text(
                '''• Model for fall detection using sensor data.\n• Load and predict falls from the sensor data.''',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 20),
              Text(
                '3. Web Platform:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 5),
              Text(
                '''• Receives alerts from the mobile app.\n• Triggers immediate action based on the received alert.''',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 20),
              Text(
                'Conclusion',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 5),
              Text(
                '''The Accident Detection project integrates real-time sensor data analysis, machine learning, and communication features to ensure timely assistance for individuals in case of accidents. The system is designed to provide an efficient and reliable method for fall detection and alerting emergency contacts and centralized platforms.''',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
