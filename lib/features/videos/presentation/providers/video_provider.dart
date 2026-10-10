import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_provider.dart';
import '../../data/datasources/video_remote_datasource.dart';
import '../../data/datasources/video_remote_datasource_impl.dart';
import '../../data/repositories/video_repository_impl.dart';
import '../../domain/repositories/video_repository.dart';
import '../../domain/usecases/get_videos_usecase.dart';

final videoRemoteDatasourceProvider = Provider<VideoRemoteDatasource>(
  (ref) => VideoRemoteDatasourceImpl(dio: ref.watch(dioProvider)),
);

final videoRepositoryProvider = Provider<VideoRepository>(
  (ref) => VideoRepositoryImpl(
    remoteDatasource: ref.watch(videoRemoteDatasourceProvider),
  ),
);

final getVideosUseCaseProvider = Provider<GetVideosUseCase>(
  (ref) => GetVideosUseCase(repository: ref.watch(videoRepositoryProvider)),
);
