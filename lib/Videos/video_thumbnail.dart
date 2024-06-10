import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

void main() => runApp(const VideoApp());

/// Stateful widget to fetch and then display video content.
class VideoApp extends StatefulWidget {
  const VideoApp({Key? key}) : super(key: key);

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  final List<VideoPlayerController> _controllers = [];
  final List<Future<List<Uint8List>>> _thumbnails = [];
  final List<String> _videoUrls = [
    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'
  ]; // Initial video URL
  final int _quality = 20;
  final double _height = 200;
  final ScrollController _scrollController = ScrollController();
  bool isVideoClick = false;
  Timer? _timer;
  int _currentVideoIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeController(_videoUrls[_currentVideoIndex]);
  }

  void _initializeController(String url) {
    final VideoPlayerController controller = VideoPlayerController.network(url);
    _controllers.add(controller);
    _thumbnails.add(_generateThumbnails(controller));
    controller.initialize().then((_) {
      setState(() {});
      controller.addListener(() {
        _scrollToPosition(controller);
        if (controller.value.position >= controller.value.duration! &&
            !controller.value.isPlaying) {
          _playNextVideo();
        }
      });
    });
  }

  void _playNextVideo() {
    if (_currentVideoIndex + 1 < _videoUrls.length) {
      _currentVideoIndex++;
      _initializeController(_videoUrls[_currentVideoIndex]);
      _controllers[_currentVideoIndex - 1].dispose();
      _controllers.removeAt(_currentVideoIndex - 1);
      _thumbnails.removeAt(_currentVideoIndex - 1);
      setState(() {});
    }
  }

  Future<List<Uint8List>> _generateThumbnails(VideoPlayerController controller) async {
    List<Uint8List> byteList = [];
    final int count = 8; // Number of thumbnails

    for (int i = 1; i <= count; i++) {
      final Uint8List? bytes = await VideoThumbnail.thumbnailData(
        video: controller.dataSource,
        imageFormat: ImageFormat.JPEG,
        timeMs: (controller.value.duration!.inMilliseconds * i ~/ count),
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

  void _scrollToPosition(VideoPlayerController controller) {
    if (controller.value.isPlaying) {
      final double position = controller.value.position.inMilliseconds.toDouble();
      final double duration = controller.value.duration!.inMilliseconds.toDouble();
      final double maxExtent = _scrollController.position.maxScrollExtent;

      // Calculate the scroll position based on video position
      final double scrollPosition = (position / duration) * maxExtent;

      // Scroll the list view to the calculated position
      _scrollController.animateTo(
        scrollPosition,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _pauseVideo(VideoPlayerController controller) {
    if (controller.value.isPlaying) {
      setState(() {
        controller.pause();
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _scrollController.dispose();
    _timer?.cancel();
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
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _controllers.length,
                  itemBuilder: (context, index) {
                    final controller = _controllers[index];
                    return FutureBuilder<List<Uint8List>>(
                      future: _thumbnails[index],
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            return Column(
                              children: <Widget>[
                                AspectRatio(
                                  aspectRatio: controller.value.aspectRatio,
                                  child: VideoPlayer(controller),
                                ),
                                SizedBox(height: 20),
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 191.0),
                                        child: Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.black, width: 2),
                                          ),
                                          child: ListView.builder(
                                            controller: _scrollController,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: snapshot.data!.length,
                                            itemBuilder: (context, thumbIndex) {
                                              return GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    isVideoClick = !isVideoClick;
                                                  });
                                                  _pauseVideo(controller);
                                                },
                                                child: Image.memory(snapshot.data![thumbIndex]),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: CustomPaint(
                                        size: Size(20, 100),
                                        painter: DrawCenterLine(),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${_formatDuration(controller.value.position)} / ${_formatDuration(controller.value.duration!)}',
                                  style: const TextStyle(fontSize: 16.0),
                                ),
                                IconButton(
                                  icon: Icon(
                                    controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      controller.value.isPlaying ? controller.pause() : controller.play();
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
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _videoUrls.add('https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4');
                    if (_controllers.isEmpty) {
                      _initializeController(_videoUrls.last);
                    }
                  });
                },
                child: const Text('Add Video'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawCenterLine extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3;

    final Offset start = Offset(size.width / 2, 0);
    final Offset end = Offset(size.width / 2, size.height);

    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
