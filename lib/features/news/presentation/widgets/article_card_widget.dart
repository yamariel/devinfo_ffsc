import 'package:flutter/material.dart';

import '../../domain/entities/article_entity.dart';

class ArticleCardWidget extends StatelessWidget {
  final ArticleEntity article;
  final VoidCallback? onTap;
  const ArticleCardWidget({
    required this.article,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = article.coverImage ?? article.socialImage;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageUrl != null && imageUrl.isNotEmpty
                ? Hero(
                    tag: article.id,
                    child: Container(
                      height: 190,
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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AuthorRow(article: article),
                  const SizedBox(height: 12),
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  if (article.description.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      article.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  if (article.tags.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _ArticleTags(tags: article.tags),
                  ],
                  const SizedBox(height: 14),
                  _ArticleMetadata(article: article),
                ],
              ),
            ),
          ],
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
      height: 190,
      width: double.infinity,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Icon(
        Icons.article_outlined,
        size: 48,
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    );
  }
}

class _AuthorRow extends StatelessWidget {
  final ArticleEntity article;
  const _AuthorRow({required this.article});

  @override
  Widget build(BuildContext context) {
    final profileImage = article.authorProfileImage;

    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          foregroundImage: profileImage != null && profileImage.isNotEmpty
              ? NetworkImage(profileImage)
              : null,
          child: const Icon(Icons.person_outline, size: 20),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                article.authorName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              if (article.authorUsername.isNotEmpty)
                Text(
                  '@${article.authorUsername}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
          ),
        ),
        if (article.readablePublishDate.isNotEmpty)
          Text(
            article.readablePublishDate,
            style: Theme.of(context).textTheme.bodySmall,
          ),
      ],
    );
  }
}

class _ArticleTags extends StatelessWidget {
  final String tags;
  const _ArticleTags({required this.tags});

  @override
  Widget build(BuildContext context) {
    final visibleTags = tags
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .take(3);

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        for (final tag in visibleTags)
          Text(
            '#$tag',
            style: Theme.of(context).textTheme.labelMedium
                ?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
      ],
    );
  }
}

class _ArticleMetadata extends StatelessWidget {
  final ArticleEntity article;
  const _ArticleMetadata({required this.article});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodySmall;
    final color = Theme.of(context).colorScheme.onSurfaceVariant;

    return Row(
      children: [
        Icon(Icons.favorite_border, size: 16, color: color),
        const SizedBox(width: 4),
        Text('${article.publicReactionsCount}', style: style),
        const SizedBox(width: 16),
        Icon(Icons.mode_comment_outlined, size: 16, color: color),
        const SizedBox(width: 4),
        Text('${article.commentsCount}', style: style),
        const Spacer(),
        const Icon(Icons.schedule, size: 16),
        const SizedBox(width: 4),
        Text('${article.readingTimeMinutes} min de lecture', style: style),
      ],
    );
  }
}
