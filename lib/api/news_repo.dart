import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../screens/home/news_model.dart';

String apiKey = "8e375079dc9f404a9190af3eaba0003f";
String base_url = "https://newsapi.org/v2/everything";

final newsRepoProvider = Provider((ref) {
  return NewsRepo();
});

class NewsRepo {
  NewsRepo();
  Future<List<NewsArticle>> getAllNews({required int page}) async {
    var url = Uri.parse('$base_url?q=*&page=$page&apiKey=$apiKey');

    try {
      var res = await http.get(url);
      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);
        final List<dynamic> articlesJson = jsonData['articles'];
        final List<NewsArticle> articles = articlesJson
            .map((articleJson) => NewsArticle.fromJson(articleJson))
            .toList();
        return articles;
      } else {
        throw Exception('Failed to load news data');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to load news data');
    }
  }

  Future<List<NewsArticle>> getSearchNews({required String query}) async {
    var url = Uri.parse('$base_url?q=$query&apiKey=$apiKey');

    try {
      var res = await http.get(url);
      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);
        final List<dynamic> articlesJson = jsonData['articles'];
        final List<NewsArticle> articles = articlesJson
            .map((articleJson) => NewsArticle.fromJson(articleJson))
            .toList();

       
        return articles;
      } else {
        throw Exception('Failed to load news data');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to load news data');
    }
  }
}
