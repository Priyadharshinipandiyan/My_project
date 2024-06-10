import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Downloader',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: ImageDownloader(),
    );
  }
}

class ImageDownloader extends StatefulWidget {
  @override
  _ImageDownloaderState createState() => _ImageDownloaderState();
}

class _ImageDownloaderState extends State<ImageDownloader> {
  final String imageUrl =
      'https://uat-qshot.qliq1s.com/api/user/DownloadCategoryFile?type=Stickers&category=Q-Accessories&fileName=R1.png'; // Replace with your API endpoint
  bool downloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Downloader'),
      ),
      body: Center(
        child: downloading
            ? CircularProgressIndicator()
            : ElevatedButton(
          onPressed: () => _downloadImage(imageUrl),
          child: Text('Download Image'),
        ),
      ),
    );
  }

  Future<void> _downloadImage(String url) async {
    // final status = await Permission.storage.request();
    // if (status.isGranted) {
    //   setState(() {
    //     downloading = true;
    //   });

      final saveDir = await getApplicationCacheDirectory();

       await FlutterDownloader.enqueue(
        url: url,
        savedDir: saveDir.path,
        fileName: "downloaded_image",
        showNotification: true,
        openFileFromNotification: true,
      );

      // Register the callback function
      FlutterDownloader.registerCallback(_callback);

    // } else {
    //   print("Permission denied");
    // }
  }

  // Define the callback function
  static void _callback(String id, int status, int progress) {
    if (status == 200) {
      print('Download completed');
    } else {
      print('Download failed');
    }
  }
}
