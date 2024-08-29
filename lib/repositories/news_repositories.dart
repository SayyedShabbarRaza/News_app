import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news/model/categories_news_model.dart';
import 'package:news/model/news_model.dart';

class NewsRepository {
  Future<NewsModel> fetching(String channelName) async {
    String url =
        'https://newsapi.org/v2/top-headlines?sources=${channelName}&apiKey=fbd75da59b32401b8c800d7b97af15a3';
    try {
      final response = await http.get(Uri.parse(url));
      var data = jsonDecode(response.body.toString());
      if (response.statusCode == 200) {
        print('Status code 200');
        return NewsModel.fromJson(data);
      } else {
        print('An error occured');
        return NewsModel.fromJson(data);
      }
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  //Categories News Model
  Future<CategoriesNewsModel> fetchingCategories(String category) async {
    String url =
        'https://newsapi.org/v2/everything?q=${category}&apiKey=fbd75da59b32401b8c800d7b97af15a3';
    try {
      final response = await http.get(Uri.parse(url));
      var data = jsonDecode(response.body.toString());
      if (response.statusCode == 200) {
        print('Status code 200');
        return CategoriesNewsModel.fromJson(data);
      } else {
        print('An error occured');
        return CategoriesNewsModel.fromJson(data);
      }
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}
