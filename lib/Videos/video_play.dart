import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

void main() => runApp(const VideoApp());

/// Stateful widget to fetch and then display video content.
class VideoApp extends StatefulWidget {
  const VideoApp({super.key});

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;
  final int _quality = 20;
  final double _height = 200;
  late Future<List<Uint8List>> _thumbnails;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
      ..initialize().then((_) {
        setState(() {});
      });
    _thumbnails = _generateThumbnails();
  }

  Future<List<Uint8List>> _generateThumbnails() async {
    List<Uint8List> byteList = [];
    final int count = 8; // Number of thumbnails

    for (int i = 1; i <= count; i++) {
      final Uint8List? bytes = await VideoThumbnail.thumbnailData(
        video: _controller.dataSource,
        imageFormat: ImageFormat.JPEG,
        timeMs: (_controller.value.duration!.inMilliseconds * i ~/ count),
        quality: _quality,
      );
      if (bytes != null) {
        byteList.add(bytes);
      }
    }
    return byteList;
  }

  String _formatDuration(Duration position) {
    final minutes = position.inMinutes.toString().padLeft(2, '0');
    final seconds = (position.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Video Player Demo'),
        ),
        body: Center(
          child: FutureBuilder<List<Uint8List>>(
            future: _thumbnails,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 10, // Display only one video
                          itemBuilder: (context, index) {
                            return AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: VideoPlayer(_controller),
                            );
                          },
                        ),
                      ),
                      Text(
                        '${_formatDuration(_controller.value.position)} / ${_formatDuration(_controller.value.duration!)}',
                        style: const TextStyle(fontSize: 16.0),
                      ),
                      IconButton(
                        icon: Icon(
                          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                        ),
                        onPressed: () {
                          setState(() {
                            _controller.value.isPlaying ? _controller.pause() : _controller.play();
                          });
                        },
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Text('Unknown error occurred.');
                }
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}
