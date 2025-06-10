import 'package:eleaning/core/helper/color_helper.dart';
import 'package:eleaning/core/helper/text_style_helper.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PopularCategoryRow extends StatelessWidget {
  const PopularCategoryRow({
    super.key,
    required this.categoryTitle,
    required this.popularCategoryImagePath,
  });
  final String popularCategoryImagePath;
  final String categoryTitle;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Image.network(
                    popularCategoryImagePath,

                    height: 20.h,
                    width: 40.w,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  // right: 0,
                  child: Text(
                    categoryTitle,
                    style: TextStyleHelper.textStylefontSize18.copyWith(
                      fontWeight: FontWeight.w400,
                      color: ColorHelper.darkGrey,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(width: 4.w),
      ],
    );
  }
}
