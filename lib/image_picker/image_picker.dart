import 'package:flutter/material.dart';
import 'package:multi_image_picker_plus/multi_image_picker_plus.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ImagePickerPage(),
    );
  }
}

class ImagePickerPage extends StatefulWidget {
  @override
  _ImagePickerPageState createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  List<Asset> images = <Asset>[];

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    const SelectionSetting selectionSetting = SelectionSetting(
      min: 0,
      max: 3,
      unselectOnReachingMax: true,
    );

    try {
      resultList = await MultiImagePicker.pickImages(
        // maxImages: 5,
        // enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: const CupertinoOptions(albumButtonColor: Colors.red,),
        materialOptions: const MaterialOptions(
          actionBarColor: Colors.orange,
          actionBarTitle: "Select Images",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: Colors.orange,
          maxImages: 9,
          textOnNothingSelected: "choose the Image to edit",
          selectionLimitReachedText: "Please choose fewer than 9 images",

        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;

    setState(() {
      images = resultList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Multi Image Picker Example'),
      ),
      body: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: loadAssets,
            child: Text("Pick images"),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: images.length,
              itemBuilder: (BuildContext context, int index) {
                Asset asset = images[index];
                return AssetThumb(
                  asset: asset,
                  width: 300,
                  height: 300,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
