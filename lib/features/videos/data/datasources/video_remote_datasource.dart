import '../models/video_model.dart';

abstract class VideoRemoteDatasource {
  Future<List<VideoModel>> getVideos();
}
