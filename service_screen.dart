import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  bool _isServiceActive = false; // Default state is inactive

  @override
  void initState() {
    super.initState();
    _loadServiceState();
  }

  // Load the saved state from local storage
  void _loadServiceState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isServiceActive =
          prefs.getBool('isServiceActive') ?? false; // Default is false
    });
  }

  // Save the current state to local storage
  void _saveServiceState(bool isActive) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isServiceActive', isActive);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        automaticallyImplyLeading: false,
        title: const Text(
          'Service Control',
          style: TextStyle(
              fontWeight: FontWeight.w900, fontSize: 16, color: Colors.white),
        ),
        elevation: 8.0,
      ),
      body: Container(
        color: Colors.grey[800],
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            const Text(
              'Activate or Deactivate Service:',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                Radio<bool>(
                  value: true,
                  groupValue: _isServiceActive,
                  onChanged: (value) {
                    setState(() {
                      _isServiceActive = value!;
                    });
                    _saveServiceState(_isServiceActive); // Save the state
                  },
                  activeColor: Colors.green,
                ),
                const Text(
                  'Activated',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(width: 20.0),
                Radio<bool>(
                  value: false,
                  groupValue: _isServiceActive,
                  onChanged: (value) {
                    setState(() {
                      _isServiceActive = value!;
                    });
                    _saveServiceState(_isServiceActive); // Save the state
                  },
                  activeColor: Colors.red,
                ),
                const Text(
                  'Deactivated',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            const Spacer(),
            // Description at the bottom
            const Text(
              '''Use these controls to activate or deactivate the service. When the service is activated, it will be ready for use. Deactivating the service will stop it from functioning.''',
              style: TextStyle(color: Colors.white70, fontSize: 12.0),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
