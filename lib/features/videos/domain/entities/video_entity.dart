class VideoEntity {
  const VideoEntity({
    required this.id,
    required this.path,
    required this.videoUrl,
    required this.title,
    required this.authorName,
    this.thumbnailUrl,
    this.sourceUrl,
    this.duration,
  });

  final int id;
  final String path;
  final String videoUrl;
  final String title;
  final String authorName;
  final String? thumbnailUrl;
  final String? sourceUrl;
  final String? duration;

  String? get displayThumbnailUrl {
    if (thumbnailUrl != null) return thumbnailUrl;
    final videoId = _youtubeVideoId(sourceUrl);
    return videoId == null ? null : 'https://i.ytimg.com/vi/$videoId/hqdefault.jpg';
  }

  String get playbackUrl {
    final videoId = _youtubeVideoId(sourceUrl);
    if (videoId == null) return videoUrl;

    return Uri.https(
      'www.youtube.com',
      '/embed/$videoId',
      const {
        'playsinline': '1',
        'autoplay': '1',
        'rel': '0',
      },
    ).toString();
  }

  String? _youtubeVideoId(String? source) {
    if (source == null) return null;

    final uri = Uri.tryParse(source);
    if (uri == null || uri.scheme != 'https') return null;

    final host = uri.host.toLowerCase();
    String? videoId;

    if (host == 'youtu.be') {
      videoId = uri.pathSegments.isEmpty ? null : uri.pathSegments.first;
    } else if (host == 'youtube.com' ||
        host.endsWith('.youtube.com') ||
        host == 'youtube-nocookie.com' ||
        host.endsWith('.youtube-nocookie.com')) {
      if (uri.path == '/watch') {
        videoId = uri.queryParameters['v'];
      } else if (uri.pathSegments.length >= 2 &&
          const {'embed', 'shorts', 'live'}.contains(uri.pathSegments.first)) {
        videoId = uri.pathSegments[1];
      }
    }

    if (videoId == null ||
        !RegExp(r'^[A-Za-z0-9_-]{11}$').hasMatch(videoId)) {
      return null;
    }

    return videoId;
  }
}
