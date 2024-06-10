import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MaterialApp(
    home: CollageFrames(),
    debugShowCheckedModeBanner: false,
  ));
}

class CollageFrames extends StatefulWidget {
  const CollageFrames({super.key});

  @override
  State<CollageFrames> createState() => _CollageFramesState();
}

class _CollageFramesState extends State<CollageFrames> {
  @override
  Widget build(BuildContext context) {
    //ScreenUtil.init(context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 44),
            child: ClipPath(
              clipper: CustomClipperShape(),
              child: SizedBox(
                height: 300,
                width: 300,
                child: fiveCollage(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget fiveCollage() {
  return SingleChildScrollView(
    physics: const NeverScrollableScrollPhysics(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 150,
                width: 100,
                color: Colors.red,
              ),
              Container(
                height: 150,
                width: 100,
                color: Colors.green,
              ),
              Container(
                height: 150,
                width: 100,
                color: Colors.pink,
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 150,
                width: 150,
                color: Colors.brown,
              ),
              Container(
                height: 150,
                width: 150,
                color: Colors.blueGrey,
              ),
            ],
          ),
        )
      ],
    ),
  );
}

class CustomClipperShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.addOval(Rect.fromLTWH(0, 0, size.width, size.height));
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
