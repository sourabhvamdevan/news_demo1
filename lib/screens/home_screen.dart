import 'package:flutter/material.dart';
import '../models/article_model.dart';
import '../services/api_service.dart';
import '../widgets/news_card.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const HomeScreen({super.key, required this.onToggleTheme});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Article>> news;
  Future<List<Article>>? searchResult;
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    news = ApiService().fetchTopHeadlines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "Search news...",
            border: InputBorder.none,
          ),
          onSubmitted: (value) {
            setState(() {
              searchResult = ApiService().searchNews(value);
            });
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.dark_mode),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: FutureBuilder<List<Article>>(
        future: searchResult ?? news,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            children: snapshot.data!
                .map((article) => NewsCard(article: article))
                .toList(),
          );
        },
      ),
    );
  }
}
