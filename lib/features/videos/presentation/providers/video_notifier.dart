import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/video_entity.dart';
import 'video_provider.dart';

class VideosNotifier extends AsyncNotifier<List<VideoEntity>> {
  @override
  Future<List<VideoEntity>> build() {
    return ref.watch(getVideosUseCaseProvider).call();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(getVideosUseCaseProvider).call(),
    );
  }
}
final videosProvider = AsyncNotifierProvider<VideosNotifier, List<VideoEntity>>(
  VideosNotifier.new,
);
