import 'package:flutter/material.dart';
import '../models/article_model.dart';
import '../screens/detail_screen.dart';

class NewsCard extends StatelessWidget {
  final Article article;

  const NewsCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        leading: Image.network(article.imageUrl, width: 80, fit: BoxFit.cover),
        title: Text(article.title, maxLines: 2),
        subtitle: Text(article.source),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DetailScreen(article: article)),
          );
        },
      ),
    );
  }
}
