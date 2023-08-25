import 'dart:convert';

import 'package:bonga_chat_app/screens/features/inbox/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../features/faqs/categories_screen.dart';
import '../features/services/services_screen.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late IO.Socket socket;
  bool chatInitialized = false;
  String? clientId;
  String? ticketId;
  String? socketId;

  @override
  void initState() {
    super.initState();
    // Initialize Socket.IO connection
    socket = IO.io('https://chatdesk-prod.dialafrika.com', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.on('connect', (_) {
      // Retrieve and store the socket ID
      setState(() {
        socketId = socket.id;
      });
      print('Socket.IO connected: ${socket.id}');
    });
  }

  @override
  void dispose() {
    socket.dispose(); // Close the Socket.IO connection when done
    super.dispose();
  }

  Future<void> initializeChat() async {
    final response = await http.post(
      Uri.parse('https://chatdesk-prod.dialafrika.com/mobilechat/1/process'),
      headers: {'Content-Type': 'application/json'},
      body: '{"route": "LIVE_CHAT"}',
    );

    if (response.statusCode == 200) {
      // Parse the JSON response
      final responseData = json.decode(response.body);
      clientId = responseData['data']['payload']['message']
          ['clientId']; // Assign to instance variable
      ticketId = responseData['data']['payload']['message']
          ['ticketId']; // Assign to instance variable

      // Listen for Socket.IO events
      socket.on('connect', (_) {
        print('Socket.IO connected ${socket.id}}');

      });

      socket.on('message_from_agent', (data) {
        // Handle incoming messages from the agent
        print('Received message from agent: $data');
      });

      socket.connect(); // Connect to the Socket.IO server

      socket.on('disconnect', (_) {
        // Handle socket disconnection
        print('Socket disconnected');
      });

      socket.on('message', (data) {
        // Handle incoming messages
        print('Received message: $data');
      });
      setState(() {
        chatInitialized = true; // Update the UI state
      });
    } else {
      print('Failed to initialize chat');
    }

  }

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
              onTap: () async {
                // Initialize the chat
                await initializeChat();
                // Navigate to the ChatScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    if (clientId != null &&
                        ticketId != null &&
                        socketId != null) {
                      return ChatScreen(
                        clientId: clientId!,
                        ticketId: ticketId!,
                        socketId: socketId!,
                        socket: socket,
                      );
                    } else {
                      // Handle the case when clientId, ticketId, or socketId is null
                      return const Scaffold(
                        body: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  }),
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
                  MaterialPageRoute(
                      builder: (context) => const CategoryScreen()),
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
                  MaterialPageRoute(
                      builder: (context) => const ServiceScreen()),
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
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
