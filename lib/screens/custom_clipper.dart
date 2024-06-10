import 'package:flutter/material.dart';

class HeartFrameClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    double width = size.width;
    double height = size.height;

    path.moveTo(width / 2, height * 0.35);

    // Top left curve
    path.cubicTo(width * 0.3, 0, 0, height * 0.35, width / 2, height * 0.8);

    // Bottom left curve
    path.cubicTo(width, height * 0.35, width * 0.7, 0, width / 2, height * 0.35);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 300,
          height: 300,
          color: Colors.purple,
          child: Center(
            child: ClipPath(
              clipper: HeartFrameClipper(),
              child: Container(
                width: 300,
                height: 300,
                color: Colors.blue, // You can change the color of the container here
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MyWidget(),
  ));
}
