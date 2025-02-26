import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../apis/auth_api.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  late Future<User?> _user;
  late Future<String?> status;
  late Future<List?> notifications;

  @override
  void initState() {
    super.initState();
    setState(() {
      _user = AuthAPI().getCurrentUserInstance();
      status = _getStatus();
      notifications = provideNotification();
    });
  }

  Future<List?> provideNotification() async {
    try {
      final notify = await AuthAPI().getNotifications();
      print(notify);
      if (notify.length >= 3) {
        return notify.sublist(notify.length - 3);
      } else {
        return notify;
      }
    } catch (e) {
      debugPrint('An error occurred while getting notification: $e');
      return [];
    }
  }

  Future<String> _getStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isServiceActive = prefs.getBool('isServiceActive');
    return isServiceActive == true ? 'Active' : 'Inactive';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.9),
        automaticallyImplyLeading: false,
        title: const Text(
          'Control Panel',
          style: TextStyle(
              fontWeight: FontWeight.w900, fontSize: 16, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/notify');
            },
          ),
        ],
        elevation: 8.0, // Added shadow to AppBar
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg2.png'), // Path to your bg.png file
            fit: BoxFit.cover, // Ensures the image covers the entire background
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Greeting section
              _buildGreetingSection(),

              const SizedBox(height: 20),

              // Status Indicator section (new component)
              _buildStatusIndicator(),

              const SizedBox(height: 20),

              // Quick Access Buttons
              _buildQuickAccessButtons(context),

              const SizedBox(height: 20),

              // Latest Updates section
              _buildLatestUpdatesSection(),

              const SizedBox(height: 20),

              // Action Cards section
              _buildActionCards(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreetingSection() {
    return FutureBuilder<User?>(
      future: _user,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Text(
            'Error: ${snapshot.error}',
            style: const TextStyle(color: Colors.white),
          );
        }

        return Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8.0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Welcome back!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Icon(
                Icons.warning_amber_outlined,
                size: 30.0,
                color: Colors.white,
              ),
            ],
          ),
        );
      },
    );
  }

  // New Status Indicator Widget
  Widget _buildStatusIndicator() {
    return FutureBuilder<String?>(
      future: status, // Use the future here
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Text(
            'Error: ${snapshot.error}',
            style: const TextStyle(color: Colors.white),
          );
        }

        final currentStatus = snapshot.data ?? 'Inactive';
        return Container(
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8.0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.circle,
                color: currentStatus == 'Active' ? Colors.green : Colors.red,
                size: 12.0,
              ),
              const SizedBox(width: 10.0),
              Text(
                'Status: $currentStatus',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickAccessButtons(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Change to 3 columns to fit 6 buttons
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
      ),
      itemCount: 6, // Number of quick access buttons
      itemBuilder: (context, index) {
        final icons = [
          Icons.dataset_linked_rounded,
          Icons.emergency_share,
          Icons.chat,
          Icons.settings,
          Icons.place,
          Icons.miscellaneous_services,
        ];

        final texts = [
          'Data Center',
          'Em-Contact',
          'Chat',
          'Settings',
          'H-Centers',
          'Service',
        ];

        return GestureDetector(
          onTap: () {
            // Navigate to the appropriate page
            Navigator.pushNamed(context, '/panel${index + 1}');
          },
          child: Container(
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              color: Colors.red[700],
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8.0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icons[index], // Use icons list
                  color: Colors.white,
                  size: 30.0,
                ),
                const SizedBox(height: 8.0),
                Text(
                  texts[index], // Use texts list
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLatestUpdatesSection() {
    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Latest Updates',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10.0),
          FutureBuilder<List?>(
            future: notifications, // Fetch notifications from the future
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.white),
                );
              }

              final notificationsList = snapshot.data;
              if (notificationsList == null || notificationsList.isEmpty) {
                return const Text(
                  'No new notifications.',
                  style: TextStyle(color: Colors.white),
                );
              }

              // Display each notification
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: notificationsList.length,
                itemBuilder: (context, index) {
                  final notification = notificationsList[index];
                  final icon = notification['icon'] ?? '🔔';
                  final message = notification['message'] ?? 'No message';

                  return _buildUpdateItem(message, icon);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateItem(String message, String icon) {
    return Row(
      children: [
        Text(
          icon,
          style: TextStyle(fontSize: 16.0),
        ),
        const SizedBox(width: 10.0),
        Expanded(
          child: Text(
            message,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionCards() {
    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.red[700],
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildActionCard('Frequently asked!', Icons.question_answer, '/faq'),
          _buildActionCard('Request Assistance', Icons.help_outline, '/panel3'),
          _buildActionCard('View History', Icons.history, '/history'),
        ],
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, String url) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, url);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15.0),
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.black, size: 20.0),
            const SizedBox(width: 15.0),
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
