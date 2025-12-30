import 'package:flutter/material.dart';
import '../models/article_model.dart';
import '../services/api_service.dart';
import '../widgets/news_card.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  static const List<String> categories = [
    'business',
    'sports',
    'technology',
    'health',
    'science',
    'entertainment',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return ListTile(
            title: Text(
              category.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CategoryNewsScreen(category: category),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class CategoryNewsScreen extends StatelessWidget {
  final String category;

  const CategoryNewsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category.toUpperCase())),
      body: FutureBuilder<List<Article>>(
        future: ApiService().fetchTopHeadlinesByCategory(category),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Failed to load news'));
          }

          if (snapshot.data!.isEmpty) {
            return const Center(child: Text('No news found'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return NewsCard(article: snapshot.data![index]);
            },
          );
        },
      ),
    );
  }
}
