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

  @override
  Future<String> getArticleContent(int articleId) async {
    final response = await dio.get('/articles/$articleId');
    final content = response.data['body_html'];
    if (content is! String || content.isEmpty) {
      throw const FormatException('Le contenu de l’article est indisponible.');
    }
    return content;
  }
}
