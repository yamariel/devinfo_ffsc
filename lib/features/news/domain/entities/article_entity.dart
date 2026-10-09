class ArticleEntity {
  final int id;
  final String title;
  final String description;
  final String url;
  final String? coverImage;
  final String? socialImage;
  final String publishedAt;
  final String readablePublishDate;
  final int readingTimeMinutes;
  final int publicReactionsCount;
  final int commentsCount;
  final String tags;
  final String authorName;
  final String authorUsername;
  final String? authorProfileImage;

  const ArticleEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.url,
    this.coverImage,
    this.socialImage,
    required this.publishedAt,
    required this.readablePublishDate,
    required this.readingTimeMinutes,
    required this.publicReactionsCount,
    required this.commentsCount,
    required this.tags,
    required this.authorName,
    required this.authorUsername,
    this.authorProfileImage,
  });
}