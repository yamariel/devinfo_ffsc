import '../../domain/entities/video_entity.dart';

class VideoModel extends VideoEntity {
  const VideoModel({
    required super.id,
    required super.path,
    required super.videoUrl,
    required super.title,
    required super.authorName,
    super.thumbnailUrl,
    super.sourceUrl,
    super.duration,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    final userData = user is Map<String, dynamic>
        ? user
        : const <String, dynamic>{};
    final id = json['id'];
    final videoUrl = json['video'];
    final path = json['path'];
    final title = json['title'];

    if (id is! num ||
        videoUrl is! String ||
        videoUrl.isEmpty ||
        path is! String ||
        title is! String) {
      throw const FormatException('Format de vidéo DEV.to invalide.');
    }

    return VideoModel(
      id: id.toInt(),
      path: path,
      videoUrl: videoUrl,
      title: title,
      authorName: userData['name'] is String
          ? userData['name'] as String
          : 'Auteur inconnu',
      thumbnailUrl: _optionalString(json['cloudinary_video_url']),
      sourceUrl: _optionalString(json['video_source_url']),
      duration: _optionalString(json['video_duration_in_minutes']),
    );
  }

  static String? _optionalString(Object? value) {
    return value is String && value.isNotEmpty ? value : null;
  }
}
