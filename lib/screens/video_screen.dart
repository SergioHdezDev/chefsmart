import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:chefsmart/core/app_colors.dart';
import 'package:flutter/foundation.dart';

class VideoScreen extends StatelessWidget {
  const VideoScreen({super.key, this.url});

  final String? url;

  Future<List<Map<String, dynamic>>> fetchVideos(String collection) async {
    final snapshot = await FirebaseFirestore.instance.collection(collection).get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Videos')),
      body: FutureBuilder<List<List<Map<String, dynamic>>>>(
        future: Future.wait([
          fetchVideos('videos'),           // Videos destacados
          fetchVideos('videotutoriales'),  // Otros videotutoriales
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final featuredVideos = snapshot.data?[0] ?? [];
          final otherVideos = snapshot.data?[1] ?? [];

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Videos destacados',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 180,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: featuredVideos.length,
                    itemBuilder: (context, index) {
                      final video = featuredVideos[index];
                      final videoId = video['serverId'];
                      return GestureDetector(
                        onTap: () {
                          if (videoId != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => YoutubePlayerScreen(videoId: videoId),
                              ),
                            );
                          }
                        },
                        child: Container(
                          width: 140,
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  video['imageUrl'] ?? '',
                                  width: 140,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                video['videoName'] ?? '',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Otros videotutoriales',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: otherVideos.length,
                  itemBuilder: (context, index) {
                    final video = otherVideos[index];
                    final videoId = video['serverId'];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        leading: Image.network(video['imageUrl'] ?? ''),
                        title: Text(video['videoName'] ?? ''),
                        trailing: const Icon(Icons.play_circle_fill),
                        onTap: () {
                          if (videoId != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => YoutubePlayerScreen(videoId: videoId),
                              ),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}

class YoutubePlayerScreen extends StatefulWidget {
  final String videoId;
  const YoutubePlayerScreen({super.key, required this.videoId});

  @override
  State<YoutubePlayerScreen> createState() => _YoutubePlayerScreenState();
}

class _YoutubePlayerScreenState extends State<YoutubePlayerScreen> {
  YoutubePlayerController? _controller;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final platform = Theme.of(context).platform;
      // Solo inicializa el controlador en Android/iOS
      if (!kIsWeb && platform != TargetPlatform.windows) {
        _controller = YoutubePlayerController.fromVideoId(
          videoId: widget.videoId,
          autoPlay: true,
        );
      }
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;

    // SOLO Windows abre navegador externo
    if (!kIsWeb && platform == TargetPlatform.windows) {
      return Scaffold(
        appBar: AppBar(title: const Text('Reproduciendo video')),
        body: Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 0.5,
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              final url = 'https://www.youtube.com/watch?v=${widget.videoId}';
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(Uri.parse(url));
              } else {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No se pudo abrir el video')),
                );
              }
            },
            child: const Text('Abrir en el navegador'),
          ),
        ),
      );
    }

    // Web, Android, iOS: reproductor embebido
    return Scaffold(
      appBar: AppBar(title: const Text('Reproduciendo video')),
      body: kIsWeb
          ? YoutubePlayer(
              controller: YoutubePlayerController.fromVideoId(
                videoId: widget.videoId,
                autoPlay: true,
              ),
              aspectRatio: 16 / 9,
            )
          : (_controller != null
              ? YoutubePlayer(
                  controller: _controller!,
                  aspectRatio: 16 / 9,
                )
              : const Center(child: CircularProgressIndicator())),
    );
  }
}
