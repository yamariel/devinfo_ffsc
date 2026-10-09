import '../models/article_model.dart';

abstract class ArticleRemoteDatasource {
  Future<List<ArticleModel>> getArticles();
}
