import 'package:accident_detection_app/apis/auth_api.dart';
import 'package:accident_detection_app/model/notification_model.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {
  late Future<List?> notifications;
  List<NotificationItem> notificationList = [];

  @override
  void initState() {
    super.initState();
    notifications = provideNotification();
  }

  Future<List?> provideNotification() async {
    try {
      final notify = await AuthAPI().getNotifications();
      List<NotificationItem> tempNotifications = [];
      for (var notifyItem in notify) {
        tempNotifications.add(NotificationItem.fromMap(notifyItem));
      }
      setState(() {
        notificationList = tempNotifications;
      });
      return notify;
    } catch (e) {
      debugPrint('An error occurred while getting notification: $e');
      return [];
    }
  }

  _markAsRead(int index) {
    setState(() {
      notificationList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: TextStyle(
              fontWeight: FontWeight.w900, fontSize: 16, color: Colors.white),
        ),
        backgroundColor: Colors.black.withOpacity(0.9),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder(
        future: notifications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || notificationList.isEmpty) {
            return Center(child: Text('No Notifications'));
          }

          return ListView.builder(
            itemCount: notificationList.length,
            itemBuilder: (context, index) {
              final notification = notificationList[index];
              return ListTile(
                leading: Text(notification.icon),
                title: Text(notification.message),
                tileColor: Colors.white,
                trailing: IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () => _markAsRead(index),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
