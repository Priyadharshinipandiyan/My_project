import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Two Containers with Images'),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 4,
                  child: ContainerWithImages(),
                ),
                Container(
                  padding: EdgeInsets.all(16.0),
                  color: Colors.grey[200],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.home, size: 40, color: Colors.blue),
                      Icon(Icons.favorite, size: 40, color: Colors.red),
                      Icon(Icons.settings, size: 40, color: Colors.green),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ContainerWithImages extends StatefulWidget {
  @override
  _ContainerWithImagesState createState() => _ContainerWithImagesState();
}

class _ContainerWithImagesState extends State<ContainerWithImages> {
  String _firstImageUrl =
      'https://dfstudio-d420.kxcdn.com/wordpress/wp-content/uploads/2019/06/digital_camera_photo-980x653.jpg';
  String _secondImageUrl =
      'https://cdn.futura-sciences.com/cdn-cgi/image/width=1024,quality=50,format=auto/sources/images/dossier/773/01-intro-773.jpg';

  late String _draggedImageUrl;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          DragTarget(
            onAccept: (imageUrl) {
              setState(() {
                String temp = _firstImageUrl;
                _firstImageUrl = _secondImageUrl;
                _secondImageUrl = temp;
              });
            },
            builder: (context, candidateData, rejectedData) {
              return Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue,
                ),
                child: LongPressDraggable(
                  data: _firstImageUrl,
                  child: Image.network(
                    _firstImageUrl,
                    fit: BoxFit.cover,
                  ),
                  feedback: Container(
                    height: 40,
                    width: 40,
                    child: Image.network(
                      _firstImageUrl,
                      fit: BoxFit.contain,
                    ),
                  ),
                  onDragStarted: () {
                    _draggedImageUrl = _firstImageUrl;
                  },
                ),
              );
            },
          ),
          DragTarget(
            onAccept: (imageUrl) {
              setState(() {
                String temp = _firstImageUrl;
                _firstImageUrl = _secondImageUrl;
                _secondImageUrl = temp;
              });
            },
            builder: (context, candidateData, rejectedData) {
              return Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.green,
                ),
                child: LongPressDraggable(
                  data: _secondImageUrl,
                  child: Image.network(
                    _secondImageUrl,
                    fit: BoxFit.cover,
                  ),
                 feedbackOffset: Offset.zero,
                  feedback: Image.network(
                    _secondImageUrl,
                    fit: BoxFit.cover,
                  ),
                  onDragStarted: () {
                    _draggedImageUrl = _secondImageUrl;
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
