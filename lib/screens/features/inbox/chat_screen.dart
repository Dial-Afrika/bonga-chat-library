import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  late io.Socket socket;
  late String clientId;
  late String ticketId;
  bool chatInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeSocket();
  }

  void initializeSocket() {
    socket = io.io('https://chatdesk-prod.dialafrika.com/webchat/1/process', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.on('connect', (_) {
      print('Socket connected');

      // Initiate the chat and handle the response
      socket.emit('initChat', {"route": "LIVE_CHAT"});
      socket.on('initChatResponse', (data) {
        setState(() {
          clientId = data['data']['payload']['message']['clientId'];
          ticketId = data['data']['payload']['message']['ticketId'];
          // Here, you can handle the welcome message and the sample payload
          String welcomeMessage = data['data']['message'];
          var payloadData = data['data']['payload']['data'];
          _messages.add(ChatMessage(
            senderId: clientId,
            clientId: clientId,
            text: welcomeMessage,
          ));
          chatInitialized = true;
        });
      });
    });

    socket.on('message', (data) {
      print('Received message: $data');
      setState(() {
        _messages.add(ChatMessage(
          senderId: data['senderId'],
          text: data['text'],
          clientId: 'clientId',

        ));
      });
    });

    socket.connect();
  }


  void sendMessage() {
    if (_messageController.text.trim().isNotEmpty && chatInitialized) {
      final message = {
        'senderId': clientId,
        'text': _messageController.text.trim(),
      };
      socket.emit('message', message);
      setState(() {
        _messages.add(ChatMessage(
          senderId: clientId,
          text: _messageController.text.trim(),
          clientId: clientId,
        ));
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _messages[index];
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(hintText: 'Type a message...'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendMessage,
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
  late String senderId;
  final String clientId;
  final String text;

  ChatMessage({super.key, required this.senderId, required this.text, required this.clientId});

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
