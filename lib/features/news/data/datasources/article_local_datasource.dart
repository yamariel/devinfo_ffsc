import '../models/article_model.dart';

abstract class ArticleLocalDatasource {
  Future<List<ArticleModel>> getCachedArticles();
  Future<void> cachedArticles(List<ArticleModel> articles);
}
