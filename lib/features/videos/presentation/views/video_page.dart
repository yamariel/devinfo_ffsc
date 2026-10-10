import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/video_entity.dart';
import '../providers/video_notifier.dart';
import '../widgets/video_card.dart';
import 'video_player_page.dart';

class VideoPage extends ConsumerWidget {
  const VideoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videos = ref.watch(videosProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vidéos'),
        actions: [
          IconButton(
            tooltip: 'Actualiser les vidéos',
            onPressed: videos.isLoading
                ? null
                : () => ref.read(videosProvider.notifier).refresh(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: videos.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.cloud_off_outlined, size: 48),
                const SizedBox(height: 12),
                const Text(
                  'Impossible de charger les vidéos.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                FilledButton.icon(
                  onPressed: () =>
                      ref.read(videosProvider.notifier).refresh(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Réessayer'),
                ),
              ],
            ),
          ),
        ),
        data: (videoList) {
          if (videoList.isEmpty) {
            return const Center(child: Text('Aucune vidéo disponible.'));
          }

          return RefreshIndicator(
            onRefresh: () => ref.read(videosProvider.notifier).refresh(),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: videoList.length,
              itemBuilder: (context, index) {
                final video = videoList[index];
                return VideoCard(
                  video: video,
                  onTap: () => _openVideo(context, video),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _openVideo(BuildContext context, VideoEntity video) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => VideoPlayerPage(video: video),
      ),
    );
  }
}
