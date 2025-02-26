import 'package:flutter/material.dart';
import '../apis/auth_api.dart';
import '../model/user_model.dart';

class DataCenterScreen extends StatefulWidget {
  const DataCenterScreen({Key? key}) : super(key: key);

  @override
  State<DataCenterScreen> createState() => _DataCenterScreenState();
}

class _DataCenterScreenState extends State<DataCenterScreen> {
  final _stepFormKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>()
  ];

  int _currentStep = 0;
  bool _termsAccepted = false;
  bool _isLoading = false;

  // Controllers for form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _altPhoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() async {
    try {
      final user = await AuthAPI().readCurrentUser();
      setState(() {
        _nameController.text = user!.name;
        _ageController.text = user.age.toString();
        _phoneController.text = user.phoneNumber;
        _altPhoneController.text = user.altPhoneNumber;
        _locationController.text = user.location;
        _addressController.text = user.address;
      });
    } catch (e) {
      debugPrint('Error loading user data: $e');
    }
  }

  @override
  void dispose() {
    // Dispose of controllers to free resources
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _altPhoneController.dispose();
    _locationController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Personal Data',
          style: TextStyle(
              fontWeight: FontWeight.w900, fontSize: 16, color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black.withOpacity(0.9),
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepTapped: (step) => setState(() => _currentStep = step),
        onStepContinue: _currentStep == _stepFormKeys.length - 1 ? null : _next,
        onStepCancel: _cancel,
        steps: [
          Step(
            title: const Text('Personal Info'),
            content: Form(
              key: _stepFormKeys[0],
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _ageController,
                    decoration: const InputDecoration(labelText: 'Age'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your age';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            isActive: _currentStep >= 0,
            state: _currentStep >= 0 ? StepState.complete : StepState.disabled,
          ),
          Step(
            title: const Text('Contact Info'),
            content: Form(
              key: _stepFormKeys[1],
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _phoneController,
                    decoration:
                        const InputDecoration(labelText: 'Phone Number'),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _altPhoneController,
                    decoration: const InputDecoration(
                        labelText: 'Alternative Phone Number'),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an alternative phone number';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            isActive: _currentStep >= 1,
            state: _currentStep >= 1 ? StepState.complete : StepState.disabled,
          ),
          Step(
            title: const Text('Location Info'),
            content: Form(
              key: _stepFormKeys[2],
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _locationController,
                    decoration: const InputDecoration(labelText: 'Location'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your location';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(labelText: 'Address'),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your address';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            isActive: _currentStep >= 2,
            state: _currentStep >= 2 ? StepState.complete : StepState.disabled,
          ),
          Step(
            title: const Text('Terms & Conditions'),
            content: Form(
              key: _stepFormKeys[3],
              child: Column(
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _termsAccepted,
                        onChanged: (value) {
                          setState(() {
                            _termsAccepted = value!;
                          });
                        },
                      ),
                      const Expanded(
                        child: Text('I accept the terms and conditions'),
                      ),
                    ],
                  ),
                  if (!_termsAccepted)
                    const Text(
                      'You must accept the terms to proceed.',
                      style: TextStyle(color: Colors.red),
                    ),
                ],
              ),
            ),
            isActive: _currentStep >= 3,
            state: _currentStep >= 3 ? StepState.complete : StepState.disabled,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red[700],
        onPressed: _submitForm,
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Icon(Icons.check, color: Colors.white),
      ),
    );
  }

  void _next() {
    final currentFormState = _stepFormKeys[_currentStep].currentState;

    if (currentFormState != null && currentFormState.validate()) {
      currentFormState.save();
      setState(() {
        _currentStep += 1;
      });
    }
  }

  void _cancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep -= 1);
    }
  }

  void _submitForm() async {
    if (_isLoading) return; // Prevent multiple clicks
    setState(() {
      _isLoading = true; // Show loading indicator
    });
    for (final key in _stepFormKeys) {
      final currentFormState = key.currentState;
      if (currentFormState == null || !currentFormState.validate()) {
        debugPrint('Form validation failed.');
        setState(() {
          _isLoading = false; // Reset loading if validation fails
        });
        return;
      }
      currentFormState.save();
    }
    if (_termsAccepted) {
      try {
        final authAPI = AuthAPI();
        final authInstance = await authAPI.getCurrentUserInstance();
        final userData = UserModel(
          uid: authInstance!.uid,
          name: _nameController.text,
          address: _addressController.text,
          age: int.parse(_ageController.text),
          altPhoneNumber: _altPhoneController.text,
          emContact: const {},
          email: authInstance.email ?? 'default@example.com',
          helpCenter: '',
          location: _locationController.text,
          phoneNumber: _phoneController.text,
          history: [],
        );
        await authAPI.updateUser(userData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Updated successfully!"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        debugPrint('Error updating user: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Update failed!"),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      } finally {
        setState(() {
          _isLoading = false; // Reset loading state
        });
      }
    } else {
      debugPrint('You must accept the terms to proceed.');
      setState(() {
        _isLoading = false;
      });
    }
  }
}
