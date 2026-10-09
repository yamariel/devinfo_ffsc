import '../entities/article_entity.dart';
import '../repositories/article_repository.dart';

class GetArticlesUsecase {
  final ArticleRepository repository;
  GetArticlesUsecase({required this.repository});

  Future<List<ArticleEntity>> call() {
    return repository.getArticles();
  }
}
