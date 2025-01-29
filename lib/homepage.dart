import 'package:flutter/material.dart';
import 'dart:async';
import 'notifications.dart';
import 'alerts.dart';
import 'active_users.dart'; // Add this import
import 'past_users.dart';

class ParkItHomePage extends StatefulWidget {
  const ParkItHomePage({super.key});

  @override
  _ParkItHomePageState createState() => _ParkItHomePageState();
}

class _ParkItHomePageState extends State<ParkItHomePage> {
  final List<String> _images = [
    'assets/car1.jpg',
    'assets/car2.jpg',
    'assets/car3.jpg',
  ];
  int _currentImageIndex = 0;

  final List<Map<String, String>> _notifications = [];

  @override
  void initState() {
    super.initState();
    _startImageCarousel();
  }

  void _startImageCarousel() {
    Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _currentImageIndex = (_currentImageIndex + 1) % _images.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ParkIt',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () =>
                showNotificationsBottomSheet(context, _notifications),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == "1") {
                setState(() {
                  _notifications.add({
                    "title": "Welcome to ParkIt",
                    "body": "New User added successfully.",
                  });
                });
                showNotification("Welcome to ParkIt", "New User added successfully.");
              } else if (value == "2") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ActiveUsersPage()),
                ); // Navigate to Active Users Page
              } else if (value == "3") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AlertPage()),
                );
              } else if (value == "4") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PastUsersPage()),
                );
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(value: "1", child: Text("New User")),
              const PopupMenuItem(value: "2", child: Text("Active Users")),
              const PopupMenuItem(value: "3", child: Text("Alerts")),
              const PopupMenuItem(value: "4", child: Text("Past Users")),
            ],
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(_images[_currentImageIndex]),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Text(
                'ParkIt',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Welcome to ParkIt...\nYour parking companion.',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
