import 'package:eleaning/core/helper/color_helper.dart';
import 'package:eleaning/core/helper/text_style_helper.dart';
import 'package:eleaning/core/extensions/navigation_extension.dart';
import 'package:eleaning/features/profile/presentation/cubit/signout/signout_cubit.dart';
import 'package:eleaning/features/profile/presentation/cubit/signout/signout_state.dart';
import 'package:eleaning/features/authentication/presentation/ui/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    AnimationController logoutAnimation,
    SignOutCubit signOutCubit,
  ) {
    showDialog(
      barrierDismissible: false,
      context: context,

      builder:
          (dialogContext) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: BlocProvider.value(
              value: signOutCubit,
              child: BlocListener<SignOutCubit, SignoutState>(
                listener: (context, state) {
                  if (state is SignoutSuccess) {
                    Navigator.of(dialogContext).pop(); // Close dialog
                    // Navigate to login screen
                    context.pushRemoveUntil(LoginScreen());
                  } else if (state is SignoutFailure) {
                    Navigator.of(dialogContext).pop(); // Close dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Sign out failed: ${state.error}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Lottie.asset(
                        "assets/images/logout.json",
                        width: 120,
                        height: 120,
                        controller: logoutAnimation,
                        repeat: false,
                        onLoaded: (composition) {
                          // Set the animation duration based on the Lottie file
                          logoutAnimation.duration = composition.duration;

                          // Start the animation
                          logoutAnimation.forward().then((_) {
                            // After animation completes, start the sign out process
                            signOutCubit.signOut();
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Signing out...',
                        style: TextStyleHelper.textStylefontSize16.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
