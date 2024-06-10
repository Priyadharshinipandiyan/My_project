// ignore_for_file: avoid_print, library_private_types_in_public_api

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Pinch Zoom Image'),
        ),
        body: const Center(
          child: PinchZoomImage(
            imageProvider: AssetImage('assets/image3.jpg'),
          ),
        ),
      ),
    );
  }
}

class ZoomModelClass {
  final Offset offset;
  final double zoom;
  ZoomModelClass({required this.offset, required this.zoom});
}

class PinchZoomImage extends StatefulWidget {
  final ImageProvider imageProvider;

  const PinchZoomImage({Key? key, required this.imageProvider})
      : super(key: key);

  @override
  _PinchZoomImageState createState() => _PinchZoomImageState();
}

class _PinchZoomImageState extends State<PinchZoomImage> {
  double _scale = 1.0;
  double _previousScale = 1.0;
  Offset _initialFocalPoint = Offset.zero;
  Offset _currentOffset = Offset.zero;
  Offset _previousOffset = Offset.zero;

  List<ZoomModelClass> undoList = [];

  ZoomModelClass zoomModelClass(int index) {
    return undoList[index];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            color: Colors.black26,
            child: GestureDetector(
              onScaleStart: _onScaleStart,
              onScaleUpdate: _onScaleUpdate,
              onScaleEnd: _onScaleEnd,
              onDoubleTap: _handleDoubleTap,
              child: ClipRect(
                child: Transform(
                  transform: Matrix4.identity()
                    ..translate(_currentOffset.dx, _currentOffset.dy)
                    ..scale(_scale),
                  alignment: FractionalOffset.center,
                  child: Image(
                    image: widget.imageProvider,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(50),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 50,
                width: 50,
                child: CircleAvatar(
                    backgroundColor: Colors.red,
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            if (undoList.isNotEmpty) {
                              undoList.remove(undoList.last);

                              final int index = undoList.length - 1;

                              if (undoList.isNotEmpty) {
                                final undoValue = zoomModelClass(index);
                                print(
                                    "Undo Scale Value :::: ${undoValue.zoom}");
                                print(
                                    "Undo Offset Value :::: ${undoValue.offset}");
                                _scale = undoValue.zoom;
                                _currentOffset = undoValue.offset;
                              }
                            }
                          });
                        },
                        icon: Icon(
                          Icons.undo,
                          color:
                          undoList.length > 1 ? Colors.white : Colors.grey,
                        ))),
              ),
              SizedBox(
                height: 50,
                width: 50,
                child: CircleAvatar(
                    backgroundColor: Colors.red,
                    child: IconButton(
                        onPressed: () {
                          undoList.clear();
                        },
                        icon: const Icon(Icons.restart_alt))),
              ),
              SizedBox(
                height: 50,
                width: 50,
                child: CircleAvatar(
                    backgroundColor: Colors.red,
                    child: IconButton(
                        onPressed: () {}, icon: const Icon(Icons.redo))),
              ),
            ],
          ),
        ),
        Slider(
          value: _scale,
          min: 1.0,
          max: 10.0,
          onChanged: (value) {
            setState(() {
              _scale = value;
            });
          },
        ),
      ],
    );
  }

  void _onScaleStart(ScaleStartDetails details) {
    _initialFocalPoint = details.focalPoint;
    _previousOffset = _currentOffset;
    _previousScale = _scale;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _scale = _previousScale * details.scale;

      print("Scale Value :::: $_scale");

      const double minScale = 1.0;
      const double maxScale = 10.0;

      _scale = _scale.clamp(minScale, maxScale);

      final Offset normalizedOffset = (_initialFocalPoint - _previousOffset);
      final Offset updatedOffset = details.focalPoint - normalizedOffset;

      _currentOffset = updatedOffset;
    });
  }

  void _onScaleEnd(ScaleEndDetails details) {
    final double finalScale = _scale;
    final Offset finalOffset = _currentOffset;

    undoList.add(ZoomModelClass(offset: finalOffset, zoom: finalScale));

    print('Final Scale: $finalScale');
    print('Final Offset: $finalOffset');

    print("The List Value is ::::: ${undoList.length}");
  }

  void _handleDoubleTap() {
    setState(() {
      _currentOffset = Offset.zero;
      _previousOffset = Offset.zero;
      if (_scale != 1.0) {
        _scale = 1.0;
        _currentOffset = Offset.zero;
      } else {
        _scale = 2.0;
      }
    });
  }
}
