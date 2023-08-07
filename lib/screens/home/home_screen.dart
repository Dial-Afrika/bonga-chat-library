import 'package:bonga_chat_app/screens/features/inbox/chat_screen.dart';
import 'package:flutter/material.dart';

import '../features/faqs/categories_screen.dart';
import '../features/services/services_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: buildSectionCard(
              title: 'Inbox',
              icon: Icons.mail_outline_rounded,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatScreen()),
                );
              },
            ),
          ),
          Expanded(
            child: buildSectionCard(
              title: 'Categories',
              icon: Icons.category,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CategoryScreen()),
                );
              },
            ),
          ),
          Expanded(
            child: buildSectionCard(
              title: 'Services',
              icon: Icons.home_repair_service_outlined,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ServiceScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSectionCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 28),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
