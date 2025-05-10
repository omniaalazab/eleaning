import 'package:eleaning/core/helper/text_style_helper.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.buttonText,
    this.buttonIcon = const SizedBox(width: .5),
    required this.onPressedFunction,
    this.sideColor,
    this.alignButton = MainAxisAlignment.center,
    this.widthButton = double.infinity,
    this.textColor = Colors.white,
    this.buttonColor = Colors.blue,
  });
  final String buttonText;

  final Color? sideColor;
  final Color textColor;
  final Color buttonColor;
  final double widthButton;
  final Function()? onPressedFunction;
  final MainAxisAlignment alignButton;
  final Widget buttonIcon;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressedFunction,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(widthButton, 55),
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: SizedBox(
        width: widthButton,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buttonIcon,
            SizedBox(width: 1.w),
            Text(
              buttonText,
              style: TextStyleHelper.textStylefontSize18.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
