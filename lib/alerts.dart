import 'package:flutter/material.dart';

class AlertPage extends StatefulWidget {
  const AlertPage({super.key});

  @override
  _AlertPageState createState() => _AlertPageState();
}

class _AlertPageState extends State<AlertPage> {
  final List<Map<String, String>> _alerts = [
    {"time": "Today", "message": "Parking full in Zone A"},
    {"time": "Yesterday", "message": "Unauthorized vehicle detected"},
    {"time": "Last Week", "message": "New user registered"},
  ];

  String _selectedFilter = "All";

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredAlerts = _selectedFilter == "All"
        ? _alerts
        : _alerts.where((alert) => alert["time"] == _selectedFilter).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alerts'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedFilter,
              items: ["All", "Today", "Yesterday", "Last Week"]
                  .map((filter) => DropdownMenuItem(
                        value: filter,
                        child: Text(filter),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedFilter = value!;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredAlerts.length,
              itemBuilder: (context, index) {
                final alert = filteredAlerts[index];
                return ListTile(
                  title: Text(alert["message"]!),
                  subtitle: Text(alert["time"]!),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.phone),
                        onPressed: () => _showContactDialog(alert),
                      ),
                      IconButton(
                        icon: const Icon(Icons.message),
                        onPressed: () => _showMessageDialog(alert),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showContactDialog(Map<String, String> alert) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Contact User"),
        content: Text("Contact user about: ${alert['message']}"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              // Add actual contact logic here
              Navigator.pop(context);
            },
            child: const Text("Call"),
          ),
        ],
      ),
    );
  }

  void _showMessageDialog(Map<String, String> alert) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Send Message"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Send a message about: ${alert['message']}"),
            const SizedBox(height: 10),
            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Type your message here",
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              // Add actual send message logic here
              Navigator.pop(context);
            },
            child: const Text("Send"),
          ),
        ],
      ),
    );
  }
}
