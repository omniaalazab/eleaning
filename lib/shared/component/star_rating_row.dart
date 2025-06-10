import 'package:flutter/material.dart';

class CustomRatingBar extends StatelessWidget {
  const CustomRatingBar({
    super.key,
    required this.rating,
    this.size = 18,
    this.ratingCount,
  });
  final double rating;
  final int? ratingCount;
  final double size;
  @override
  Widget build(BuildContext context) {
    List<Widget> startList = [];
    int realNumber = rating.floor();
    int partNumber = ((rating - realNumber) * 10).ceil();

    for (int i = 0; i < 5; i++) {
      if (i < realNumber) {
        startList.add(Icon(Icons.star, color: Colors.amber, size: size));
      } else if (i == realNumber) {
        startList.add(
          SizedBox(
            height: size,
            width: size,
            child: Stack(
              children: [
                Icon(Icons.star, color: Colors.amber, size: size),
                ClipRect(
                  clipper: Clipper(parts: partNumber),
                  child: Icon(Icons.star, color: Colors.grey, size: size),
                ),
              ],
            ),
          ),
        );
      } else {
        startList.add(Icon(Icons.star, color: Colors.grey, size: size));
      }
    }
    return Row(mainAxisSize: MainAxisSize.min, children: startList);
  }
}

class Clipper extends CustomClipper<Rect> {
  Clipper({required this.parts});

  int parts;
  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(
      (size.width / 10) * parts,
      0.0,
      size.width,
      size.height,
    );
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) => true;
}
