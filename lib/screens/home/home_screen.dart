import 'dart:convert';

import 'package:bonga_chat_app/screens/features/inbox/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
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
  late String socketId;
  String apiKey = 'YOUR_API_KEY_HERE'; // Set your API key here

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _mobileController;
  late TextEditingController _ticketMessageController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _mobileController = TextEditingController();
    _ticketMessageController = TextEditingController();

    socket = IO.io('https://chatdesk-prod.dialafrika.com', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.on('connect', (_) {
      // Retrieve and store the socket ID
      setState(() {
        socketId = socket.id!;
      });
      print('Socket.IO connected: ${socket.id}');
    });

  }

  @override
  void dispose() {
    socket.dispose(); // Close the Socket.IO connection when done

    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _ticketMessageController.dispose();
    super.dispose();
  }

  Future<void> fetchOrganizationId() async {
    final response = await http.get(
      Uri.parse('https://apiprod.dialafrika.com/organisations/$apiKey'),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final organizationId = responseData['organizationId'];

      // Now you have the organization ID, you can use it to initialize chat.
      await initializeChat(organizationId);
    } else {
      print('Failed to fetch organization ID');
    }
  }

  Future<void> initializeChatAndNavigate() async {
    final response = await http.post(
      Uri.parse('https://chatdesk-prod.dialafrika.com/mobilechat/initialize-livechat/without-client/?organizationId=1'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "contactName": _nameController.text,
        "contactEmail": _emailController.text,
        "contactMobile": _mobileController.text,
        "ticketMessage": _ticketMessageController.text,
        "socketId": socketId,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final clientId = responseData['data']['clientId'];
      final ticketId = responseData['data']['ticketId'];

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            clientId: clientId,
            ticketId: ticketId,
            socketId: socketId,
            socket: socket,
          ),
        ),
      );
    } else {
      print('Failed to initialize chat');
    }
  }

  Future<void> initializeChat(String organizationId) async {
    final response = await http.post(
      Uri.parse('https://chatdesk-prod.dialafrika.com/mobilechat/$organizationId/process'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Parse the JSON response
      final responseData = json.decode(response.body);
      clientId = responseData['data']['payload']['message']['clientId']; // Assign to instance variable
      ticketId = responseData['data']['payload']['message']['ticketId']; // Assign to instance variable

      // Listen for Socket.IO events
      socket.on('connect', (_) {
        print('Socket.IO connected ${socket.id}}');
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

  final csatQuestions = {
    'ticketId': 'widget.ticketId',
    'questions': [
      {
        'question': 'Did the agent resolve your issue?',
        'options': ['Yes', 'No'],
        'selectedOption': 'Yes',
      },
      {
        'question': 'How satisfied are you with our service?',
        'options': ['1', '2', '3', '4', '5'],
        'selectedOption': '3',
      },
      {
        'question': 'How would you rate us?',
        'options': ['1', '2', '3', '4', '5'],
        'selectedOption': '3',
      },
      {
        'question': 'How likely are you to recommend us?',
        'options': ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'],
        'selectedOption': '5',
      },

    ],
  };


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
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                      ),
                    ),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                    ),
                    TextField(
                      controller: _mobileController,
                      decoration: const InputDecoration(
                        labelText: 'Mobile',
                      ),
                    ),
                    TextField(
                      controller: _ticketMessageController,
                      decoration: const InputDecoration(
                        labelText: 'What can we help you with?',
                      ),
                    ),
                    ElevatedButton(
                      onPressed: initializeChatAndNavigate,
                      child: const Text('Start Chat'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Expanded(
          //   child: buildSectionCard(
          //     title: 'Categories',
          //     icon: Icons.category,
          //     onTap: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => const CategoryScreen()),
          //       );
          //     },
          //   ),
          // ),
          // Expanded(
          //   child: buildSectionCard(
          //     title: 'Services',
          //     icon: Icons.home_repair_service_outlined,
          //     onTap: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => const ServiceScreen()),
          //       );
          //     },
          //   ),
          // ),
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
