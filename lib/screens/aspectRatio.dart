import 'package:flutter/material.dart';

class MyImageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Replace this with your image URL
    String imageUrl = 'https://images.pexels.com/photos/60597/dahlia-red-blossom-bloom-60597.jpeg';

    return Scaffold(
      appBar: AppBar(
        title: Text('Square Image Container'),
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double maxSize = constraints.maxWidth < constraints.maxHeight
                ? constraints.maxWidth
                : constraints.maxHeight;

            return Container(
              width: 300,
              height: 400,
              color: Colors.pink,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: maxSize,
                  height: maxSize,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: ClipRect(
                    child: OverflowBox(
                      alignment: Alignment.center,
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MyImageWidget(),
  ));
}
