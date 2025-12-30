import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/article_model.dart';

class ApiService {
  static const String _apiKey = "your_api_key_here";

  static const String _baseTopHeadlines =
      "https://newsapi.org/v2/top-headlines?country=in";

  ///yeh top headlines fetch krega along with offline caching
  Future<List<Article>> fetchTopHeadlines() async {
    final prefs = await SharedPreferences.getInstance();
    final url = Uri.parse("$_baseTopHeadlines&apiKey=$_apiKey");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        prefs.setString('cached_top_headlines', response.body);
        final data = jsonDecode(response.body);
        return (data['articles'] as List)
            .map((e) => Article.fromJson(e))
            .toList();
      }
    } catch (_) {}

    final cached = prefs.getString('cached_top_headlines');
    if (cached != null) {
      final data = jsonDecode(cached);
      return (data['articles'] as List)
          .map((e) => Article.fromJson(e))
          .toList();
    }

    throw Exception("Unable to load news");
  }

  ///yeh load krega from cache agr offline hue toh

  Future<List<Article>> fetchTopHeadlinesByCategory(String category) async {
    final url = Uri.parse(
      "$_baseTopHeadlines&category=$category&apiKey=$_apiKey",
    );

    final response = await http.get(url);
    final data = jsonDecode(response.body);

    return (data['articles'] as List).map((e) => Article.fromJson(e)).toList();
  }

  ///yeh search krega news by keyboard
  Future<List<Article>> searchNews(String query) async {
    final url = Uri.parse(
      "https://newsapi.org/v2/everything?q=$query&apiKey=$_apiKey",
    );

    final response = await http.get(url);
    final data = jsonDecode(response.body);

    return (data['articles'] as List).map((e) => Article.fromJson(e)).toList();
  }
}
