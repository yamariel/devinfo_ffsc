import '../../../../core/network/network_info.dart';
import '../../domain/entities/article_entity.dart';
import '../../domain/repositories/article_repository.dart';
import '../datasources/article_local_datasource.dart';
import '../datasources/article_remote_datasource.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final ArticleRemoteDatasource remoteDatasource;
  final ArticleLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  ArticleRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
    required this.networkInfo,
  });

  @override
  Future<List<ArticleEntity>> getArticles() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteArticles = await remoteDatasource.getArticles();
        await localDatasource.cachedArticles(remoteArticles);
        return remoteArticles.map((model) => model.toEntity()).toList();
      } catch (_) {
        final cachedArticles = await localDatasource.getCachedArticles();
        return cachedArticles.map((model) => model.toEntity()).toList();
      }
    } else {
      final cachedArticles = await localDatasource.getCachedArticles();
      return cachedArticles.map((model) => model.toEntity()).toList();
    }
  }
}
