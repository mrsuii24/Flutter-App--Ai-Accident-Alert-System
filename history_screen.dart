import 'package:accident_detection_app/apis/auth_api.dart';
import 'package:flutter/material.dart';

class FallDetectionHistoryScreen extends StatefulWidget {
  const FallDetectionHistoryScreen({super.key});

  @override
  FallDetectionHistoryState createState() => FallDetectionHistoryState();
}

class FallDetectionHistoryState extends State<FallDetectionHistoryScreen> {
  List<String> fallHistory = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  void loadHistory() async {
    try {
      final currentUser = await AuthAPI().readCurrentUser();
      // Assuming the history is a list of timestamps in the format ["2025-01-30 14:34:30", ...]
      setState(() {
        fallHistory = List<String>.from(currentUser!.history);
      });
    } catch (e) {
      debugPrint('Cant fetch history!, $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Fall Detection History',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // To enable horizontal scrolling
        child: fallHistory.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: fallHistory.map((timestamp) {
                    DateTime fallTime = DateTime.parse(timestamp);
                    String formattedTime = '${fallTime.toLocal()}';
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        'Fall detected at: $formattedTime',
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  }).toList(),
                ),
              ),
      ),
    );
  }
}
