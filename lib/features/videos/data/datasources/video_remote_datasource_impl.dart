import 'package:dio/dio.dart';

import '../models/video_model.dart';
import 'video_remote_datasource.dart';

class VideoRemoteDatasourceImpl implements VideoRemoteDatasource {
  const VideoRemoteDatasourceImpl({required this.dio});

  final Dio dio;

  @override
  Future<List<VideoModel>> getVideos() async {
    final response = await dio.get<List<dynamic>>('/videos');
    final data = response.data;
    if (data == null) {
      throw const FormatException('La réponse de l’API vidéos est vide.');
    }

    return data
        .map((item) {
          if (item is! Map<String, dynamic>) {
            throw const FormatException(
              'Une vidéo reçue de l’API est invalide.',
            );
          }
          return VideoModel.fromJson(item);
        })
        .toList(growable: false);
  }
}
