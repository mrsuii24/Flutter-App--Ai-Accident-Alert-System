import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ', style: TextStyle(color: Colors.white),),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildFAQItem(
              question: 'What is the Accident Detection Project?',
              answer:
                  '''The Accident Detection project is a mobile application designed to detect falls using sensor data (accelerometer and gyroscope). Upon detecting a fall, it sends alerts to emergency contacts and a centralized web platform, including the user\'s location and other important details.''',
            ),
            _buildFAQItem(
              question: 'How does the app detect falls?',
              answer:
                  '''The app uses data from the accelerometer and gyroscope to monitor the movement and orientation of the device. A pre-trained TensorFlow model analyzes this data to predict if a fall has occurred.''',
            ),
            _buildFAQItem(
              question: 'Can I set up multiple emergency contacts?',
              answer:
                  '''Currently, the app allows you to set only one emergency contact. However, we are considering adding the ability to set up multiple contacts in future updates.''',
            ),
            _buildFAQItem(
              question: 'What kind of alerts does the app send?',
              answer:
                  '''The app sends two types of alerts: an email alert to the emergency contact with the user\'s location and a notification to a centralized web platform containing the user\'s location, IP address, and other relevant details.''',
            ),
            _buildFAQItem(
              question: 'What happens after an alert is sent?',
              answer:
                  '''Once the alert is received, the centralized web platform stores the user\'s details and triggers the necessary actions, such as notifying authorities or emergency services, to provide timely assistance.''',
            ),
            _buildFAQItem(
              question: 'Is the app available for both Android and iOS?',
              answer:
                  '''Yes, the app is available for both Android and iOS devices. You can download it from the respective app stores.''',
            ),
            _buildFAQItem(
              question: 'How do I update my emergency contact?',
              answer:
                  '''You can update your emergency contact directly from the app settings. Simply enter the new contact\'s email address to replace the existing one.''',
            ),
            _buildFAQItem(
              question: 'Is my location tracked continuously?',
              answer:
                  '''The app tracks the user\'s location only when a fall is detected, and the alert is triggered. Continuous location tracking is not performed to ensure user privacy.''',
            ),
            _buildFAQItem(
              question: 'How accurate is the fall detection?',
              answer:
                  '''The accuracy of fall detection depends on the quality of sensor data and the specific scenario. However, the system has been trained using a large dataset to minimize false positives and negatives.''',
            ),
            _buildFAQItem(
              question: 'Can I use the app without an internet connection?',
              answer:
                  '''The app requires an internet connection to send alerts via email and notifications. Without internet access, the app will not be able to send alerts in case of a fall.''',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem({required String question, required String answer}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              answer,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
