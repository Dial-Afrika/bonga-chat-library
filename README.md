# bonga_chat_sdk

Bonga chat app UI Library

## Getting Started


## Table of Contents

1. [Introduction](#introduction)
2. [Getting Started](#getting-started)
    - [Installation](#installation)
    - [Configuration](#configuration)
3. [Usage](#usage)
    - [Initializing the Chat](#FAQs)
    - [Initializing the Chat](#Services)
    - [Sending Messages](#chat)
4. [Customization](#customization)
    - [Styling](#styling)
5. [Advanced](#advanced)
    - [Listening to Events](#listening-to-events)
6. [Troubleshooting](#troubleshooting)

## 1. Introduction
This documentation provides step-by-step instructions on how to integrate and use Bonga Ticketing System in your own Flutter and Kotlin projects.

## 2. Installation

Clone the Project using the command below

`git clone https://github.com/Dial-Afrika/bonga-chat-library.git`

### Configuration

**Packages used**

google_fonts: ^5.1.0
http: ^1.1.0
get: ^4.6.5
socket_io_client: ^2.0.3+1
uuid: ^3.0.7

## 3. Usage

#### FAQS - Categories
On clicking the Category Icon users can easily access your FAQs by categories as setup on the `Bonga Platform`. The SDK provides a convenient interface to handle this process.

```
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
```

#### Services
On clicking the Services Icon users can easily access your Services as setup on the `Bonga Platform`. The SDK provides a convenient interface to handle this process.

```
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
```
#### Chat
On clicking the Chat Icon a ticket is created for the user on the `Bonga Ticketing module`, the user is connected to an agent and can easily get support and assistance.

```
 Future<void> initializeChat() async {
    final response = await http.post(
      Uri.parse('https://chatdesk-prod.dialafrika.com/mobilechat/1/process'),
      headers: {'Content-Type': 'application/json'},
      body: '{"route": "LIVE_CHAT"}',
    );
```

## 5. Event listeners

```
      // Listen for Socket.IO events
      socket.on('connect', (_) {
        print('Socket.IO connected ${socket.id}}');

      });

      socket.on('agent_found', (data) {
        // Handle agent found
        print('Assigned to: $data');
      });

      socket.on('message_from_agent', (data) {
        // Handle incoming messages from the agent
        print('Received message from agent: $data');
      });

      socket.on('live_ticket_closed', (data) {
        // Handle live ticket closed
        print('Live ticket closed: $data');
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
```

## Styling

You can customize the appearance of the chat interface to match your app's design


Please replace placeholders like `[YOUR_OrganizationID]`, e.g https://chatdesk-prod.dialafrika.com/mobilechat/organization_id/process, and customize the application according to your project's details. You can also create separate markdown files for styling.