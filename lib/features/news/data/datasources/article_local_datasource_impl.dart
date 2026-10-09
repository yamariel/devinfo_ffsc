import 'package:hive_flutter/hive_flutter.dart';

import '../models/article_model.dart';
import 'article_local_datasource.dart';

class ArticleLocalDatasourceImpl implements ArticleLocalDatasource {
  final Box<ArticleModel> articlesBox;
  ArticleLocalDatasourceImpl({required this.articlesBox});

  @override
  Future<void> cachedArticles(List<ArticleModel> articles) async {
    await articlesBox.clear();
    await articlesBox.addAll(articles);
  }

  @override
  Future<List<ArticleModel>> getCachedArticles() async {
    return articlesBox.values.toList();
  }
}
