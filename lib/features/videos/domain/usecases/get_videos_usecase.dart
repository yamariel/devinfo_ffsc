import '../entities/video_entity.dart';
import '../repositories/video_repository.dart';

class GetVideosUseCase {
  const GetVideosUseCase({required this.repository});

  final VideoRepository repository;

  Future<List<VideoEntity>> call() => repository.getVideos();
}
