import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Local notifications plugin instance
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Function to show a notification
Future<void> showNotification(String title, String body) async {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'parkit_channel_id',
    'ParkIt Notifications',
    channelDescription: 'Notifications for ParkIt',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: true,
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidNotificationDetails);

  await flutterLocalNotificationsPlugin.show(
    0, // Notification ID
    title, // Title of the notification
    body, // Body of the notification
    platformChannelSpecifics,
    payload: 'item_id', // Payload (optional)
  );
}

// Function to display the notifications bottom sheet
void showNotificationsBottomSheet(
    BuildContext context, List<Map<String, String>> notifications) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notifications',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 10),
            const Divider(),
            if (notifications.isEmpty) ...[
              const Center(
                child: Text(
                  'No Notifications',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ] else ...[
              ListView.builder(
                shrinkWrap: true,
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return ListTile(
                    leading: const Icon(Icons.notifications, color: Colors.deepPurple),
                    title: Text(notification["title"]!),
                    subtitle: Text(notification["body"]!),
                  );
                },
              ),
            ],
          ],
        ),
      );
    },
  );
}
