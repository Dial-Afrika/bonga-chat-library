import 'package:bonga_chat_app/models/services/services.dart';
import 'package:flutter/material.dart';

import '../../../api/services/service_faq_api.dart';
import '../../../api/services/services_api.dart';
import '../faqs/faq_screen.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  _ServiceScreenState createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  List<Services> _services = [];

  @override
  void initState() {
    super.initState();
    _fetchServices();
  }

  Future<void> _fetchServices() async {
    try {
      final services = await ServicesApi.fetchServices();
      setState(() {
        _services = services;
      });
    } catch (e) {
      print('Error fetching Services: $e');
    }
  }

  // Function to navigate to the FAQ screen and fetch FAQs based on the selected category's value
  Future<void> _navigateToServiceDetailScreen(String serviceValue) async {
    final serviceDetail = await ServiceFaqApi.fetchFaqs(serviceValue);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FaqScreen(faqs: serviceDetail),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services'),
      ),
      body: _services.isNotEmpty
          ? ListView.builder(
        itemCount: _services.length,
        itemBuilder: (context, index) {
          final service = _services[index];
          return Card(
            child: ListTile(
              title: Text(service.label),
              subtitle: Text(service.description),
              onTap: () {
                _navigateToServiceDetailScreen(service.value);
              },
            ),
          );
        },
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
