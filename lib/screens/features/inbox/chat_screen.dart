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

    // Subscribe to 'message_from_agent' event
    socket.on('message_from_agent', (data) {
      // Handle incoming messages from the agent
      print('Received message from agent in ChatScreen: $data');

      setState(() {
        final message = data['message'];
        _messages.add(ChatMessage(
          senderId: message['clientId'],
          text: message['message'],
          clientId: widget.clientId,
          timestamp: DateTime.parse(message['created_at']),
        ));
      });
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

  // void dispose() {
  //   socket.dispose();
  //   super.dispose();
  // }


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
                return _messages[index];
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
        alignment:
            senderId == clientId ? Alignment.centerRight : Alignment.centerLeft,
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
