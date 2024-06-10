// import 'package:flutter/material.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
// import 'image_downloader.dart'; // Assuming your DownloadImage widget is in a separate file
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized(); // Ensure that plugins are initialized
//   await FlutterDownloader.initialize();
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Image Downloader'),
//         ),
//         body: Center(
//           child: DownloadImage(
//             imageUrl: 'https://images.pexels.com/photos/60597/dahlia-red-blossom-bloom-60597.jpeg', // Replace with your image URL
//           ),
//         ),
//       ),
//     );
//   }
// }