import 'package:flutter/material.dart';

import '../../../models/faq/faq.dart';

class FaqScreen extends StatelessWidget {
  final List<FaqModel> faqs;

  const FaqScreen({super.key, required this.faqs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQs'),
      ),
      body: ListView.builder(
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          final faq = faqs[index];
          return ListTile(
            title: Text(faq.label),
            subtitle: Text(faq.description),
          );
        },
      ),
    );
  }
}
