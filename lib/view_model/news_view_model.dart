import 'package:news/model/categories_news_model.dart';
import 'package:news/model/news_model.dart';
import 'package:news/repositories/news_repositories.dart';

class NewsViewModel {
  final _rep = NewsRepository();

  Future<NewsModel> fetching(String channelName) async {
    final response = await _rep.fetching(channelName);
    return response;
  }

  Future<CategoriesNewsModel> fetchingCategories(String category) async {
    final response = await _rep.fetchingCategories(category);
    return response;
  }
}
