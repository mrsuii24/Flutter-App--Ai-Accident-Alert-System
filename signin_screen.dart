import 'package:accident_detection_app/widget/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:accident_detection_app/apis/auth_api.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  void _signUpWithGoogle(BuildContext context) async {
    try {
      final authAPI = AuthAPI();
      final userCredential = await authAPI.googleSignin();
      if (userCredential != null) {
        Navigator.of(context).pushReplacement<void, void>(MaterialPageRoute(
          builder: (BuildContext context) {
            return const BottomNavBar();
          },
        ));
      } else {
        debugPrint('Google Sign-In Failed');
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
                  label: const Text("Sign in with Google"),
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
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: const Text(
                    "Dont have an account? Sign up",
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
