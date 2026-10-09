import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/network/dio_provider.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/network/network_info_impl.dart';
import '../../../../core/storage/hive_service.dart';
import '../../data/datasources/article_local_datasource.dart';
import '../../data/datasources/article_local_datasource_impl.dart';
import '../../data/datasources/article_remote_datasource.dart';
import '../../data/datasources/article_remote_datasource_impl.dart';
import '../../data/models/article_model.dart';
import '../../data/repositories/article_repository_impl.dart';
import '../../domain/repositories/article_repository.dart';
import '../../domain/usecases/get_articles_usecase.dart';

//état du réseau
final connectivityProvider = Provider<Connectivity>((ref) => Connectivity());

final networkInfoProvider = Provider<NetworkInfo>(
  (ref) => NetworkInfoImpl(connectivity: ref.watch(connectivityProvider)),
);

//box de sauvegarde local
final articlesBoxProvider = Provider<Box<ArticleModel>>(
  (ref) => Hive.box<ArticleModel>(HiveService.articlesBoxName),
);

final dioClientProvider = dioProvider;

final articleRemoteDataSourceProvider = Provider<ArticleRemoteDatasource>(
  (ref) => ArticleRemoteDatasourceImpl(dio: ref.watch(dioClientProvider)),
);

final articleLocalDataSourceProvider = Provider<ArticleLocalDatasource>(
  (ref) =>
      ArticleLocalDatasourceImpl(articlesBox: ref.watch(articlesBoxProvider)),
);

final articleRepositoryProvider = Provider<ArticleRepository>(
  (ref) => ArticleRepositoryImpl(
    remoteDatasource: ref.watch(articleRemoteDataSourceProvider),
    localDatasource: ref.watch(articleLocalDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  ),
);

final getArticleUseCaseProvider = Provider<GetArticlesUsecase>(
  (ref) => GetArticlesUsecase(repository: ref.watch(articleRepositoryProvider)),
);
