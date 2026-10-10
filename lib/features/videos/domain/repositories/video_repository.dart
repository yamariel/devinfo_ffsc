import '../entities/video_entity.dart';

abstract class VideoRepository {
  Future<List<VideoEntity>> getVideos();
}
