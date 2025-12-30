import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/article_model.dart';

class ApiService {
  static const String _apiKey = "api_key_here";
  static const String _baseUrl =
      "https://newsapi.org/v2/top-headlines?country=in";

  Future<List<Article>> fetchTopHeadlines() async {
    final prefs = await SharedPreferences.getInstance();
    final url = Uri.parse("$_baseUrl&apiKey=$_apiKey");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        prefs.setString('cached_news', response.body);
        final data = jsonDecode(response.body);
        return (data['articles'] as List)
            .map((e) => Article.fromJson(e))
            .toList();
      }
    } catch (_) {}

    final cached = prefs.getString('cached_news');
    if (cached != null) {
      final data = jsonDecode(cached);
      return (data['articles'] as List)
          .map((e) => Article.fromJson(e))
          .toList();
    }

    throw Exception("No data available");
  }

  Future<List<Article>> searchNews(String query) async {
    final url = Uri.parse(
      "https://newsapi.org/v2/everything?q=$query&apiKey=$_apiKey",
    );

    final response = await http.get(url);
    final data = jsonDecode(response.body);

    return (data['articles'] as List).map((e) => Article.fromJson(e)).toList();
  }
}
