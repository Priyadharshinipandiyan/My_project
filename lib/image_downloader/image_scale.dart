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
          title: Text('Tile Swapping Demo'),
        ),
        body: TileSwappingDemo(),
      ),
    );
  }
}

class TileSwappingDemo extends StatefulWidget {
  @override
  _TileSwappingDemoState createState() => _TileSwappingDemoState();
}

class _TileSwappingDemoState extends State<TileSwappingDemo> {
  List<String> tiles = ['Tile 1', 'Tile 2', 'Tile 3', 'Tile 4'];

  void swapTiles() {
    setState(() {
      tiles.insert(1, tiles.removeAt(0));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: swapTiles,
          child: Text('Swap Tiles'),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TileItem(tiles[0]),
            TileItem(tiles[1]),
            TileItem(tiles[2]),
            TileItem(tiles[3]),
          ],
        ),
      ],
    );
  }
}

class TileItem extends StatelessWidget {
  final String title;

  TileItem(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      color: Colors.blueGrey,
      child: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }
}
