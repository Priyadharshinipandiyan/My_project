import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker & Cache Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _imageFile == null
                ? const Text('No Image Selected')
                : Image.file(_imageFile!),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Pick Image'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _retrieveAndShowImage,
              child: Text('Retrieve and Show Image'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      await _saveImageToCache(imageFile);
      setState(() {
        _imageFile = imageFile;
      });
    }
  }

  Future<void> _saveImageToCache(File imageFile) async {
    final cacheDirectory = await getTemporaryDirectory();
    final cachePath = '${cacheDirectory.path}/cached_image.jpg';
    await imageFile.copy(cachePath);
  }

  Future<void> _retrieveAndShowImage() async {
    final cacheDirectory = await getTemporaryDirectory();
    final cachePath = '${cacheDirectory.path}/cached_image.jpg';

    setState(() {
      _imageFile = File(cachePath);
    });
  }
}
