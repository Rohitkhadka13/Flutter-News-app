import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:news_app/models/news_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsRepository {
  final apiKey = dotenv.env['API_KEY'];

  Future<NewsModel> fetchNews() async {
    String url = "https://newsapi.org/v2/everything?q=general&apiKey=$apiKey";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return NewsModel.fromJson(body);
    } else {
      throw Exception("Failed to load news");
    }
  }

  Future<NewsModel> searchNews(String query) async {
    String url =
        "https://newsapi.org/v2/everything?q=${Uri.encodeComponent(query)}&apiKey=$apiKey";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return NewsModel.fromJson(body);
    } else {
      throw Exception("Failed to load news for query: $query");
    }
  }
}
