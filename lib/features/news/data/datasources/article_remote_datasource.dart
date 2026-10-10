import '../models/article_model.dart';

abstract class ArticleRemoteDatasource {
  Future<List<ArticleModel>> getArticles();
  Future<String> getArticleContent(int articleId);
}
