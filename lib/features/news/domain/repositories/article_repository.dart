import '../entities/article_entity.dart';

abstract class ArticleRepository {
  Future<List<ArticleEntity>> getArticles();
}