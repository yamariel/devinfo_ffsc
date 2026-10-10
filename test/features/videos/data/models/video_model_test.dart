import 'package:devinfo/features/videos/data/models/video_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('VideoModel.fromJson', () {
    test('parse les champs vidéo et le nom de l’auteur', () {
      final video = VideoModel.fromJson({
        'type_of': 'video_article',
        'id': 4812457,
        'path': '/sarvar_04/example',
        'cloudinary_video_url': null,
        'video': 'https://www.youtube.com/embed/7gHYehieEnQ',
        'title': 'Une vidéo de démonstration',
        'video_duration_in_minutes': '00:00',
        'video_source_url': 'https://youtu.be/7gHYehieEnQ',
        'user': {'name': 'Sarvar Nadaf'},
      });

      expect(video.id, 4812457);
      expect(video.title, 'Une vidéo de démonstration');
      expect(video.videoUrl, 'https://www.youtube.com/embed/7gHYehieEnQ');
      expect(video.authorName, 'Sarvar Nadaf');
      expect(video.thumbnailUrl, isNull);
      expect(
        video.displayThumbnailUrl,
        'https://i.ytimg.com/vi/7gHYehieEnQ/hqdefault.jpg',
      );
      expect(video.sourceUrl, 'https://youtu.be/7gHYehieEnQ');
      expect(
        video.playbackUrl,
        'https://www.youtube.com/embed/7gHYehieEnQ'
        '?playsinline=1&autoplay=1&rel=0',
      );
    });

    test('préfère la miniature DEV.to à celle générée depuis YouTube', () {
      final video = VideoModel.fromJson({
        'id': 1,
        'path': '/author/video',
        'video': 'https://www.youtube.com/embed/7gHYehieEnQ',
        'video_source_url': 'https://youtu.be/7gHYehieEnQ',
        'cloudinary_video_url': 'https://cdn.example.com/thumbnail.webp',
        'title': 'Vidéo',
        'user': {'name': 'Auteur'},
      });

      expect(
        video.displayThumbnailUrl,
        'https://cdn.example.com/thumbnail.webp',
      );
    });

    test('normalise une URL YouTube watch avec ses paramètres de partage', () {
      final video = VideoModel.fromJson({
        'id': 1,
        'path': '/author/video',
        'video': 'https://www.youtube.com/embed/7gHYehieEnQ',
        'video_source_url':
            'https://www.youtube.com/watch?v=7gHYehieEnQ&si=tracking',
        'title': 'Vidéo',
        'user': {'name': 'Auteur'},
      });

      expect(
        video.playbackUrl,
        'https://www.youtube.com/embed/7gHYehieEnQ'
        '?playsinline=1&autoplay=1&rel=0',
      );
    });

    test('garde l’URL vidéo de DEV.to si aucune URL source YouTube existe', () {
      final video = VideoModel.fromJson({
        'id': 1,
        'path': '/author/video',
        'video': 'https://player.mux.com/abc123',
        'video_source_url': null,
        'title': 'Vidéo',
        'user': {'name': 'Auteur'},
      });

      expect(video.playbackUrl, 'https://player.mux.com/abc123');
    });

    test('signale une vidéo dont les champs obligatoires sont invalides', () {
      expect(
        () => VideoModel.fromJson({
          'id': 'identifiant invalide',
          'path': '/example',
          'video': '',
          'title': 'Vidéo invalide',
        }),
        throwsFormatException,
      );
    });
  });
}
