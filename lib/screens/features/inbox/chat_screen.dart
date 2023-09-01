import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;


class ChatScreen extends StatefulWidget {
  final String clientId;
  final String ticketId;
  final String socketId;
  final IO.Socket socket;
  const ChatScreen(
      {
        required this.clientId,
        required this.ticketId,
        required this.socketId,
        required this.socket,
      super.key,
      });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late IO.Socket socket;
  final TextEditingController _messageController = TextEditingController();
  final List<Widget> _messages = [];

  @override
  void initState() {
    super.initState();
    socket = widget.socket; // Use the provided socket connection

    socket.on('agent_found', (data) {
      // Handle agent found
      print('Assigned to: $data');
    });

    // Subscribe to 'message_from_agent' event
    socket.on('message_from_agent', (data) {
      print('Received data: $data');

      if (data is Map<String, dynamic>) {
        final message = data['message'] as String;
        final createdAt = DateTime.parse(data['created_at']);
        final agentId = data['agentId'];
        // final agentName = jsonData['name'];

        final agentMessageWidget = AgentMessage(
          senderId: agentId,
          agentId: agentId,
          text: message,
          timestamp: createdAt,
        );

        setState(() {
          _messages.add(agentMessageWidget);
        });
      } else {
        print('Received data is not a valid JSON map: $data');
      }
    });

    socket.on('live_ticket_closed', (data) {
      // Handle live ticket closed
      print('Live ticket closed: $data');
    });

    // Subscribe to 'message' event
    socket.on('message', (data) {
      final message = data['message'];

      setState(() {
        _messages.add(ChatMessage(
          senderId: message['clientId'],
          text: message['message'],
          clientId: widget.clientId,
          timestamp: DateTime.parse(message['created_at']),
        ));
      });
    });

    print(
        "ChatScreen initialized with clientId: ${widget.clientId} and ticketId: ${widget.ticketId}");
  }


  void sendMessage(String message) async {
    final messageData = {
      "route": "LIVE_CHAT",
      "payload": {
        "clientMessage": message,
        "socketId": widget.socketId,
        "ticketId": widget.ticketId,
        "clientId": widget.clientId,
      }
    };

    String jsonMessage = json.encode(messageData);
    print("Sending message: $jsonMessage");

    try {
      socket.emit('sendMessage', jsonMessage);
      print('Message sent: $message');

      final response = await http.post(
        Uri.parse('https://chatdesk-prod.dialafrika.com/webchat/1/process'),
        headers: {'Content-Type': 'application/json'},
        body: jsonMessage,
      );

      if (response.statusCode == 200) {
        print('Message sent successfully');
      } else {
        print('Failed to send message');
      }
    } catch (e) {
      print('Error sending message: $e');
    }

    setState(() {
      _messages.add(ChatMessage(
        senderId: widget.clientId,
        text: message,
        clientId: widget.clientId,
        timestamp: DateTime.now().toUtc(),
      ));
    });

    _messageController.clear();
  }


  Future<void> retrieveMessageHistory() async {
    final payload = {
      "route": "RETRIEVE_CHAT",
      "payload": {
        "clientId": widget.clientId,
      }
    };

    final response = await http.post(
      Uri.parse('https://chatdesk-prod.dialafrika.com/webchat/1/process'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(payload),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final threads = responseData['data']['payload']['tickets'][0]['threads'];
      final List<ChatMessage> newMessages = [];

      for (var thread in threads) {
        final clientId = thread['clientId'];
        final message = thread['message'];
        final timestamp = DateTime.parse(thread['created_at']);

        newMessages.add(ChatMessage(
          senderId: clientId == widget.clientId ? clientId : widget.clientId,
          text: message,
          clientId: widget.clientId,
          timestamp: timestamp,
        ));
      }

      setState(() {
        _messages.addAll(newMessages); // Add the new messages to the existing list
      });
    } else {
      print('Failed to retrieve message history');
    }
  }



  @override
  Widget build(BuildContext context) {
    if (widget.ticketId == null) {
      // Handle the case when values are null
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Error: Required data not available.'),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('ticketId: ${widget.ticketId}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) {
                final message = _messages[index];
                if (message is AgentMessage) {
                  return AgentMessage(
                    senderId: message.agentId,
                    agentId: message.agentId,
                    text: message.text,
                    timestamp: message.timestamp,
                    // agentName: message.agentName,
                  );
                } else if (message is ChatMessage) {
                  return ChatMessage(
                    senderId: message.senderId,
                    text: message.text,
                    clientId: message.clientId,
                    timestamp: message.timestamp,
                  );
                }
                return const SizedBox(); // Handle other message types if any
              },


            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_messageController.text.trim().isNotEmpty) {
                      sendMessage(_messageController.text.trim());
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String senderId;
  final String clientId;
  final DateTime timestamp;
  final String text;

  const ChatMessage({
    super.key,
    required this.senderId,
    required this.text,
    required this.clientId,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Align(
        alignment: senderId == clientId ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: senderId == clientId ? Colors.blue : Colors.grey,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Text(
            text,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class AgentMessage extends StatelessWidget {
  final String senderId;
  final String agentId;
  final DateTime timestamp;
  final String text;
  // final String? agentName;

  const AgentMessage({
    Key? key,
    required this.senderId,
    required this.agentId,
    required this.timestamp,
    required this.text,
    // this.agentName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Align(
        alignment: senderId == agentId ? Alignment.centerLeft : Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: senderId == agentId ? Colors.grey : Colors.blue,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   '$agentName (Agent)',
              //   style: TextStyle(
              //     color: senderId == agentId ? Colors.black : Colors.white,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              const SizedBox(height: 4),
              Text(
                text,
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


