import 'package:devinfo/features/news/data/models/article_model.dart';
import 'package:dio/dio.dart';

import 'article_remote_datasource.dart';

class ArticleRemoteDatasourceImpl implements ArticleRemoteDatasource {
  final Dio dio;
  ArticleRemoteDatasourceImpl({required this.dio});
  @override
  Future<List<ArticleModel>> getArticles() async {
    final response = await dio.get("/articles?tag=french");
    final List list = response.data;
    return list.map((json) => ArticleModel.fromJson(json)).toList();
  }
}
