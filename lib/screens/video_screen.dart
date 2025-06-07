import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoScreen extends StatelessWidget {
  const VideoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final featuredVideos = [
      {
        'title': 'SANCOCHO DE GALLINA',
        'thumbnail': 'https://img.youtube.com/vi/ETOmVqIkseI/0.jpg',
        'url': 'https://www.youtube.com/watch?v=ETOmVqIkseI'
      },
      {
        'title': 'AJIACO SANTAFEREÑO',
        'thumbnail': 'https://img.youtube.com/vi/LJbhZs8PR2E/0.jpg',
        'url': 'https://www.youtube.com/watch?v=LJbhZs8PR2E'
      },
    ];

    final otherVideos = [
      {
        'title': 'EMPANADAS VALLUNAS',
        'thumbnail': 'https://img.youtube.com/vi/vVHqwCq6Tms/0.jpg',
        'url': 'https://www.youtube.com/watch?v=vVHqwCq6Tms'
      },
      {
        'title': 'TAMALES TOLIMENSES',
        'thumbnail': 'https://img.youtube.com/vi/YIwedQ7p5E8/0.jpg',
        'url': 'https://www.youtube.com/watch?v=YIwedQ7p5E8'
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Videos')),
      body: SingleChildScrollView(
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
                  final videoId = YoutubePlayerController.convertUrlToId(video['url']!);
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
                              video['thumbnail']!,
                              width: 140,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            video['title']!,
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
                final videoId = YoutubePlayerController.convertUrlToId(video['url']!);
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: Image.network(video['thumbnail']!),
                    title: Text(video['title']!),
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
  late YoutubePlayerController _controller;

  @override
  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.videoId,
      autoPlay: true,
    );  
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerControllerProvider(
      controller: _controller,
      child: Scaffold(
        appBar: AppBar(title: const Text('Reproduciendo video')),
        body: YoutubePlayer(
          controller: _controller,
          aspectRatio: 16 / 9,
        ),
      ),
    );
  }
}
