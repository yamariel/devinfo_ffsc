import '../../domain/entities/video_entity.dart';
import '../../domain/repositories/video_repository.dart';
import '../datasources/video_remote_datasource.dart';

class VideoRepositoryImpl implements VideoRepository {
  const VideoRepositoryImpl({required this.remoteDatasource});

  final VideoRemoteDatasource remoteDatasource;

  @override
  Future<List<VideoEntity>> getVideos() => remoteDatasource.getVideos();
}
