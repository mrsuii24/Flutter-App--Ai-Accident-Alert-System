import 'package:flutter/material.dart';

import '../apis/auth_api.dart';

class EmergencyContactScreen extends StatefulWidget {
  const EmergencyContactScreen({Key? key}) : super(key: key);

  @override
  _EmergencyContactScreenState createState() => _EmergencyContactScreenState();
}

class _EmergencyContactScreenState extends State<EmergencyContactScreen> {
  final _emailControllers = List.generate(3, (_) => TextEditingController());
  final _formKey = GlobalKey<FormState>();
  bool isFirstEmailValid = false;
  bool isSecondEmailValid = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    loadUserdata();
  }

  void loadUserdata() async {
    try {
      final userdata = await AuthAPI().readCurrentUser();
      setState(() {
        for (var i = 0; i < 3; i++) {
          if (userdata!.emContact.containsKey('emergency_contact_${i + 1}')) {
            _emailControllers[i].text =
                userdata.emContact['emergency_contact_${i + 1}']!;
          }
        }
      });
    } catch (e) {
      debugPrint('$e');
    }
  }

  void _saveEmails() async {
    try {
      if (_isLoading) return;
      setState(() {
        _isLoading = true; // Show loading indicator
      });
      final Map<String, String> emContact = {};
      for (int i = 0; i < 3; i++) {
        final email = _emailControllers[i].text.trim();
        if (email.isNotEmpty) {
          emContact['emergency_contact_${i + 1}'] = email;
        }
      }

      final user = await AuthAPI().readCurrentUser();
      final updatedUser = user!.copyWith(emContact: emContact);
      await AuthAPI().updateUser(updatedUser);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Updated successfully!"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      debugPrint('$e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Update failed!"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false; // Show loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Emergency Contacts',
          style: TextStyle(
              fontWeight: FontWeight.w900, fontSize: 16, color: Colors.white),
        ),
        backgroundColor: Colors.black.withOpacity(0.9),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: Colors.grey[800],
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ...List.generate(3, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _emailControllers[index],
                        decoration: InputDecoration(
                          labelText: 'Emergency Contact ${index + 1} Email',
                          labelStyle: const TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          // If the email is not empty, validate its format
                          if (value != null &&
                              value.isNotEmpty &&
                              !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                  .hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          // Update validation flags based on email validity
                          if (index == 0) {
                            setState(() {
                              isFirstEmailValid = value.isNotEmpty &&
                                  RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                      .hasMatch(value);
                            });
                          } else if (index == 1) {
                            setState(() {
                              isSecondEmailValid = value.isNotEmpty &&
                                  RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                      .hasMatch(value);
                            });
                          }
                        },
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 20), // Space before the disclaimer
              const Text(
                '''Your emergency contact emails will be used solely for notifying you in case of an emergency. We do not share or store this information beyond its intended purpose.''',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _saveEmails();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
