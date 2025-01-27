import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'homepage.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required to ensure Flutter initializes correctly.
  await initializeNotifications(); // Set up local notifications.
  runApp(ParkItApp());
}

// Initialize notifications
Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      // Handle the user's interaction with the notification
      if (response.payload != null) {
        debugPrint("Notification clicked with payload: ${response.payload}");
      }
    },
  );
}

// Function to show notifications
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
    title, // Title
    body, // Body
    platformChannelSpecifics,
    payload: 'item_id', // Payload to send additional data (optional)
  );
}

// Main app entry point
class ParkItApp extends StatelessWidget {
  const ParkItApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ParkIt',
      home: const ParkItHomePage(), // Navigate to HomePage
    );
  }
}
