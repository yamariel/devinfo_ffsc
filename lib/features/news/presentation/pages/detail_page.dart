import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/article_entity.dart';
import '../providers/news_provider.dart';

class DetailPage extends ConsumerWidget {
  final ArticleEntity article;

  const DetailPage({super.key, required this.article});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageUrl = article.coverImage ?? article.socialImage;
    final articleContent = ref.watch(articleContentProvider(article.id));

    return Scaffold(
      appBar: AppBar(title: Text('Article de ${article.authorName}')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              imageUrl != null && imageUrl.isNotEmpty
                  ? Hero(
                      tag: article.id,
                      child: Container(
                        height: 240,
                        width: double.infinity,
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.fill,
                          errorBuilder: (context, error, stackTrace) =>
                              const _ArticleImagePlaceholder(),
                        ),
                      ),
                    )
                  : const _ArticleImagePlaceholder(),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _AuthorInformation(article: article),
                    const SizedBox(height: 20),
                    Text(
                      article.title,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (article.tags.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _ArticleTags(tags: article.tags),
                    ],
                    const SizedBox(height: 20),
                    _ArticleStatistics(article: article),
                    const SizedBox(height: 24),
                    Divider(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                    const SizedBox(height: 16),
                    articleContent.when(
                      loading: () => const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      error: (error, stackTrace) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (article.description.isNotEmpty)
                            Text(
                              article.description,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(height: 1.6),
                            )
                          else
                            const Text(
                              'Le contenu de l’article est indisponible.',
                            ),
                          const SizedBox(height: 12),
                          TextButton.icon(
                            onPressed: () => ref.invalidate(
                              articleContentProvider(article.id),
                            ),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Réessayer'),
                          ),
                        ],
                      ),
                      data: (content) => Html(data: content),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArticleImagePlaceholder extends StatelessWidget {
  const _ArticleImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      width: double.infinity,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Icon(
        Icons.article_outlined,
        size: 56,
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    );
  }
}

class _AuthorInformation extends StatelessWidget {
  const _AuthorInformation({required this.article});

  final ArticleEntity article;

  @override
  Widget build(BuildContext context) {
    final profileImage = article.authorProfileImage;

    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          foregroundImage: profileImage != null && profileImage.isNotEmpty
              ? NetworkImage(profileImage)
              : null,
          child: const Icon(Icons.person_outline),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                article.authorName,
                style: Theme.of(context).textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              if (article.authorUsername.isNotEmpty)
                Text(
                  '@${article.authorUsername}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
          ),
        ),
        if (article.readablePublishDate.isNotEmpty)
          Flexible(
            child: Text(
              article.readablePublishDate,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
      ],
    );
  }
}

class _ArticleTags extends StatelessWidget {
  const _ArticleTags({required this.tags});

  final String tags;

  @override
  Widget build(BuildContext context) {
    final articleTags = tags
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final tag in articleTags)
          Chip(
            label: Text('#$tag'),
            visualDensity: VisualDensity.compact,
            side: BorderSide.none,
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          ),
      ],
    );
  }
}

class _ArticleStatistics extends StatelessWidget {
  const _ArticleStatistics({required this.article});

  final ArticleEntity article;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurfaceVariant;
    final textStyle = Theme.of(context).textTheme.bodySmall;

    return Wrap(
      spacing: 20,
      runSpacing: 12,
      children: [
        _Statistic(
          icon: Icons.favorite_border,
          value: '${article.publicReactionsCount}',
          color: color,
          textStyle: textStyle,
        ),
        _Statistic(
          icon: Icons.mode_comment_outlined,
          value: '${article.commentsCount}',
          color: color,
          textStyle: textStyle,
        ),
        _Statistic(
          icon: Icons.schedule,
          value: '${article.readingTimeMinutes} min de lecture',
          color: color,
          textStyle: textStyle,
        ),
      ],
    );
  }
}

class _Statistic extends StatelessWidget {
  const _Statistic({
    required this.icon,
    required this.value,
    required this.color,
    required this.textStyle,
  });

  final IconData icon;
  final String value;
  final Color color;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 6),
        Text(value, style: textStyle),
      ],
    );
  }
}
