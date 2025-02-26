import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../apis/auth_api.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDark = false;
  final AuthAPI _authAPI = AuthAPI();

  void _signOut(BuildContext context) async {
    _authAPI.googleSignout();
    Navigator.pushReplacementNamed(context, '/signin');
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: _isDark ? Brightness.dark : Brightness.light,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
        scaffoldBackgroundColor: Colors.grey[800],
      ),
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Settings',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.black.withOpacity(0.9),
            automaticallyImplyLeading: false,
          ),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg2.png'), // Path to your bg.png file
                fit: BoxFit
                    .cover, // Ensures the image covers the entire background
              ),
            ),
            child: Center(
              child: SizedBox(
                width: 400,
                child: ListView(
                  children: [
                    _SingleSection(
                      title: 'Organization',
                      children: [
                        _CustomListTile(
                          title: 'Profile',
                          icon: Icons.person_outline_rounded,
                          onTap: _navigateToProfile,
                        ),
                        _CustomListTile(
                          title: 'Messaging',
                          icon: Icons.message_outlined,
                          onTap: _navigateToMessaging, // Navigate to Messaging
                        ),
                      ],
                    ),
                    const Divider(color: Colors.white),
                    _SingleSection(
                      children: [
                        _CustomListTile(
                          title: 'Help & Feedback',
                          icon: Icons.help_outline_rounded,
                          onTap: _navigateToHelp, // Navigate to Help & Feedback
                        ),
                        _CustomListTile(
                          title: 'About',
                          icon: Icons.info_outline_rounded,
                          onTap: _navigateToAbout, // Navigate to About
                        ),
                        _CustomListTile(
                          title: 'Sign out',
                          icon: Icons.exit_to_app_rounded,
                          onTap: () => _signOut(context), // Handle sign-out
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  // Navigation Functions
  void _navigateToProfile() {
    Navigator.pushNamed(context, '/panel1'); // Navigate to Profile screen
  }

  void _navigateToMessaging() {
    Navigator.pushNamed(context, '/panel3'); // Navigate to Messaging screen
  }

  void _navigateToHelp() {
    Navigator.pushNamed(context, '/help'); // Navigate to Help & Feedback screen
  }

  void _navigateToAbout() {
    Navigator.pushNamed(context, '/about'); // Navigate to About screen
  }
}

class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  final Function()? onTap; // Added onTap callback
  const _CustomListTile(
      {Key? key,
      required this.title,
      required this.icon,
      this.trailing,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      leading: Icon(icon, color: Colors.white),
      trailing: trailing,
      onTap: onTap, // Handle the tap event
    );
  }
}

class _SingleSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  const _SingleSection({
    Key? key,
    this.title,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title!,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ...children,
      ],
    );
  }
}
