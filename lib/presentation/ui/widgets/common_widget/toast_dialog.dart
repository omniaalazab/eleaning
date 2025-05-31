import 'package:eleaning/core/helper/color_helper.dart';
import 'package:eleaning/core/helper/text_style_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

import 'package:sizer/sizer.dart';

class CreateDialogToaster {
  static Future showErrorDialogDefult(
    String msgTitle,
    String masgContent,
    var context,
  ) {
    return showPlatformDialog(
      context: context,
      builder:
          (context) => PlatformAlertDialog(
            title: Container(
              alignment: Alignment.center,
              child: Text(
                msgTitle,
                style: TextStyleHelper.textStylefontSize22.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            content: Container(
              width: 100,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 15),
                    Text(
                      masgContent,
                      style: TextStyleHelper.textStylefontSize14,
                    ),
                    const SizedBox(height: 15),
                    CircularProgressIndicator(color: ColorHelper.blue),
                  ],
                ),
              ),
            ),
          ),

      // titlePadding:
      //     const EdgeInsets.only(top: 10),
    );
  }

  static Future<void> showConfirmDialogDefault(
    String msgTitle,
    String msgContent,
    BuildContext context,
  ) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          contentPadding: const EdgeInsets.all(16.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 80,
                color: ColorHelper.blue,
              ),
              SizedBox(height: 10.h),
              Text(msgTitle, style: TextStyleHelper.textStylefontSize18),
              SizedBox(height: 10.h),
              Text(msgContent, style: TextStyleHelper.textStylefontSize16),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancle", style: const TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "OK",
                style: TextStyleHelper.textStylefontSize16.copyWith(
                  color: ColorHelper.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static void showLogoutDialog(
    var context,
    AnimationController doneController,
  ) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder:
          (context) => Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  "assets/images/logout.json",
                  onLoaded: (composition) {
                    doneController.duration = composition.duration;
                    doneController.forward();
                  },
                  controller: doneController,
                  repeat: false,
                ),
              ],
            ),
          ),
    );
  }

  static void showErrorToast(String msgText) {
    Fluttertoast.showToast(
      msg: msgText,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 6,
      backgroundColor: ColorHelper.red,
      textColor: ColorHelper.white,
      fontSize: 16.0,
    );
  }

  static void showSucessToast(String msgText) {
    Fluttertoast.showToast(
      msg: msgText,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 6,
      backgroundColor: const Color.fromARGB(255, 50, 161, 23),
      textColor: ColorHelper.white,
      fontSize: 16.0,
    );
  }
}
