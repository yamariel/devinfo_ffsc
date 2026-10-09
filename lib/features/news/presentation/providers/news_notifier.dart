import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/article_entity.dart';
import '../providers/news_provider.dart';

class NewsNotifier extends AsyncNotifier<List<ArticleEntity>> {
  @override
  Future<List<ArticleEntity>> build() {
    final getArticleUseCase = ref.watch(getArticleUseCaseProvider);
    return getArticleUseCase.call();
  }

  // permet de recharger manuellement la liste des articles
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final getArticleUseCase = ref.read(getArticleUseCaseProvider);
      return getArticleUseCase.call();
    });
  }
}

final newsNotifierProvider =
    AsyncNotifierProvider<NewsNotifier, List<ArticleEntity>>(NewsNotifier.new);
