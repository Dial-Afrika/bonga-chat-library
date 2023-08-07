import 'package:flutter/material.dart';
import '../../../api/faq/categories_api.dart';
import '../../../api/faq/faq_api.dart';
import '../../../models/faq/category.dart';
import 'faq_screen.dart'; // Create a new FAQ screen for displaying FAQs

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Categories> _categories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final categories = await CategoriesApi.fetchCategories();
      setState(() {
        _categories = categories;
      });
    } catch (e) {
      print('Error fetching categories: $e');
      // Handle error, show error message, etc.
    }
  }

  // Function to navigate to the FAQ screen and fetch FAQs based on the selected category's value
  Future<void> _navigateToFaqScreen(String categoryValue) async {
    final faqs = await FaqApi.fetchFaqs(categoryValue);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FaqScreen(faqs: faqs),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: _categories.isNotEmpty
          ? ListView.builder(
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          return Card(
            child: ListTile(
              title: Text(category.label),
              subtitle: Text(category.description),
              onTap: () {
                _navigateToFaqScreen(category.value);
              },
            ),
          );
        },
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
