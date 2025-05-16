import 'package:eleaning/core/constant_text.dart';
import 'package:eleaning/core/helper/color_helper.dart';
import 'package:eleaning/core/helper/text_style_helper.dart';
import 'package:eleaning/extensions/media_query_extension.dart';
import 'package:eleaning/extensions/navigation_extension.dart';
import 'package:eleaning/presentation/ui/screens/auth/login.dart';
import 'package:eleaning/presentation/ui/widgets/common_widget/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SendMailForReset extends StatelessWidget {
  const SendMailForReset({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.screenWidth / 20,
          vertical: context.screenHeight / 10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              ConstantText.checkMail,
              style: TextStyleHelper.textStylefontSize26,
            ),
            SizedBox(height: 2.h),
            Text(
              ConstantText.sendMailMessage,
              style: TextStyleHelper.textStylefontSize18,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 6.h),
            Image.asset("assets/images/mail1.webp", height: 30.h, width: 70.w),

            SizedBox(height: 6.h),
            CustomElevatedButton(
              buttonText: ConstantText.continueToLogin,
              buttonColor: ColorHelper.blue,
              textColor: ColorHelper.white,
              onPressedFunction: () {
                context.push(LoginScreen());
              },
            ),
          ],
        ),
      ),
    );
  }
}
