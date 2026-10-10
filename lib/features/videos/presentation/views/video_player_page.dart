import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../domain/entities/video_entity.dart';

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({required this.video, super.key});

  final VideoEntity video;

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late final WebViewController _controller;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (mounted) {
              setState(() {
                _isLoading = true;
                _errorMessage = null;
              });
            }
          },
          onPageFinished: (_) {
            if (mounted) setState(() => _isLoading = false);
          },
          onWebResourceError: (error) {
            if (error.isForMainFrame == false) return;
            if (mounted) {
              setState(() {
                _isLoading = false;
                _errorMessage = error.description;
              });
            }
          },
        ),
      );
    _loadVideo();
  }

  Future<void> _loadVideo() async {
    final uri = Uri.tryParse(widget.video.playbackUrl);
    if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'L’adresse de cette vidéo est invalide.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final headers = <String, String>{};
      if (_isYouTubeHost(uri.host)) {
        final appId = (await PackageInfo.fromPlatform()).packageName;
        if (appId.isEmpty) {
          throw StateError(
            'Impossible de déterminer l’identifiant de l’application.',
          );
        }
        headers['Referer'] = 'https://$appId/';
      }

      await _controller.loadRequest(uri, headers: headers);
    } catch (error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Impossible d’ouvrir la vidéo : $error';
        });
      }
    }
  }

  bool _isYouTubeHost(String host) {
    return host == 'youtube.com' ||
        host.endsWith('.youtube.com') ||
        host == 'youtube-nocookie.com' ||
        host.endsWith('.youtube-nocookie.com');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.video.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            tooltip: 'Recharger la vidéo',
            onPressed: _loadVideo,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              fit: StackFit.expand,
              children: [
                WebViewWidget(controller: _controller),
                if (_isLoading)
                  const ColoredBox(
                    color: Colors.black12,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                if (_errorMessage != null)
                  ColoredBox(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.error_outline, size: 40),
                            const SizedBox(height: 8),
                            Text(_errorMessage!, textAlign: TextAlign.center),
                            TextButton(
                              onPressed: _loadVideo,
                              child: const Text('Réessayer'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.video.title,
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Par ${widget.video.authorName}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
