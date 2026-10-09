import 'package:hive/hive.dart';

import '../../domain/entities/article_entity.dart';

part 'article_model.g.dart';

@HiveType(typeId: 0)
class ArticleModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String url;

  @HiveField(4)
  final String? coverImage;

  @HiveField(5)
  final String? socialImage;

  @HiveField(6)
  final String publishedAt;

  @HiveField(7)
  final String readablePublishDate;

  @HiveField(8)
  final int readingTimeMinutes;

  @HiveField(9)
  final int publicReactionsCount;

  @HiveField(10)
  final int commentsCount;

  @HiveField(11)
  final String tags;

  @HiveField(12)
  final String authorName;

  @HiveField(13)
  final String authorUsername;

  @HiveField(14)
  final String? authorProfileImage;

  ArticleModel({
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

  // mappage depuis la structure JSON exacte de l'api
  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    final userMap = json['user'] as Map<String, dynamic>?;

    return ArticleModel(
      id: json['id'] as int,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      coverImage: json['cover_image'] as String?,
      socialImage: json['social_image'] as String?,
      publishedAt: json['published_at'] ?? '',
      readablePublishDate: json['readable_publish_date'] ?? '',
      readingTimeMinutes: json['reading_time_minutes'] ?? 0,
      publicReactionsCount: json['public_reactions_count'] ?? 0,
      commentsCount: json['comments_count'] ?? 0,
      tags: json['tags'] ?? '',
      authorName: userMap?['name'] ?? 'Inconnu',
      authorUsername: userMap?['username'] ?? '',
      authorProfileImage:
          userMap?['profile_image_90'] as String? ??
          userMap?['profile_image'] as String?,
    );
  }

  // conversion vers l'entité du Domaine
  ArticleEntity toEntity() {
    return ArticleEntity(
      id: id,
      title: title,
      description: description,
      url: url,
      coverImage: coverImage,
      socialImage: socialImage,
      publishedAt: publishedAt,
      readablePublishDate: readablePublishDate,
      readingTimeMinutes: readingTimeMinutes,
      publicReactionsCount: publicReactionsCount,
      commentsCount: commentsCount,
      tags: tags,
      authorName: authorName,
      authorUsername: authorUsername,
      authorProfileImage: authorProfileImage,
    );
  }

  // conversion depuis une entité
  factory ArticleModel.fromEntity(ArticleEntity entity) {
    return ArticleModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      url: entity.url,
      coverImage: entity.coverImage,
      socialImage: entity.socialImage,
      publishedAt: entity.publishedAt,
      readablePublishDate: entity.readablePublishDate,
      readingTimeMinutes: entity.readingTimeMinutes,
      publicReactionsCount: entity.publicReactionsCount,
      commentsCount: entity.commentsCount,
      tags: entity.tags,
      authorName: entity.authorName,
      authorUsername: entity.authorUsername,
      authorProfileImage: entity.authorProfileImage,
    );
  }
}
