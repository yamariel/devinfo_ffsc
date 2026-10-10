import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/news_notifier.dart';
import '../widgets/article_card_widget.dart';
import 'detail_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final articles = ref.watch(newsNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('DevInfo')),
      body: articles.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Une erreur est survenue'),
              TextButton(
                onPressed: () =>
                    ref.read(newsNotifierProvider.notifier).refresh(),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
        data: (articleList) {
          if (articleList.isEmpty) {
            return const Center(child: Text('Aucun article disponible.'));
          }

          return RefreshIndicator(
            onRefresh: () => ref.read(newsNotifierProvider.notifier).refresh(),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: articleList.length,
              itemBuilder: (context, index) => ArticleCardWidget(
                article: articleList[index],
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailPage(article: articleList[index]),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
