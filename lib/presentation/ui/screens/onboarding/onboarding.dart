import 'package:eleaning/core/constant_text.dart';
import 'package:eleaning/core/helper/color_helper.dart';
import 'package:eleaning/core/helper/text_style_helper.dart';
import 'package:eleaning/data/models/onboarding_model.dart';
import 'package:eleaning/extensions/media_query_extension.dart';
import 'package:eleaning/extensions/navigation_extension.dart';
import 'package:eleaning/presentation/ui/screens/auth/login.dart';
import 'package:eleaning/presentation/ui/screens/auth/register.dart';
import 'package:eleaning/presentation/ui/widgets/common_widget/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  var onboardingcontroller = PageController();
  List<OnboardingModel> onboardingModels = [
    OnboardingModel(
      imagePath: "assets/images/onboard1.webp",
      title: ConstantText.onboardingTitle1,
      subtitle: ConstantText.onboardingSubtitle1,
    ),
    OnboardingModel(
      imagePath: "assets/images/onboard2.webp",
      title: ConstantText.onboardingTitle2,
      subtitle: ConstantText.onboardingSubtitle2,
    ),
    OnboardingModel(
      imagePath: "assets/images/onboard3.webp",
      title: ConstantText.onboardingTitle3,
      subtitle: ConstantText.onboardingSubtitle3,
    ),
  ];
  bool islastPage = false;

  _skip() {
    onboardingcontroller.jumpToPage(onboardingModels.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.screenWidth / 100,
            vertical: context.screenHeight / 100,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _skip,
                    child: Text(
                      ConstantText.skip,
                      style: TextStyleHelper.textStylefontSize14.copyWith(
                        color: ColorHelper.blue,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: PageView.builder(
                  controller: onboardingcontroller,
                  physics: const BouncingScrollPhysics(),
                  itemCount: onboardingModels.length,
                  itemBuilder: (context, index) {
                    return OnBoardingItem(
                      onBoardingModel: onboardingModels[index],
                    );
                  },
                  onPageChanged: (value) {
                    if (value == onboardingModels.length - 1) {
                      setState(() {
                        islastPage = true;
                      });
                    } else {
                      setState(() {
                        islastPage = false;
                      });
                    }
                  },
                ),
              ),
              SmoothPageIndicator(
                onDotClicked: (index) {
                  onboardingcontroller.jumpToPage(index);
                },
                controller: onboardingcontroller,
                count: onboardingModels.length,
                effect: ExpandingDotsEffect(
                  dotHeight: 2.h,
                  dotWidth: 4.w,
                  dotColor: ColorHelper.blue,
                  activeDotColor: ColorHelper.black,
                ),
              ),
              SizedBox(height: 1.h),
              CustomElevatedButton(
                buttonText: ConstantText.register,
                onPressedFunction: () {
                  context.push(Register());
                },
              ),
              SizedBox(height: 3.h),
              CustomElevatedButton(
                buttonText: ConstantText.login,
                buttonColor: ColorHelper.white,
                textColor: ColorHelper.blue,
                onPressedFunction: () {
                  context.push(Login());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnBoardingItem extends StatelessWidget {
  const OnBoardingItem({super.key, required this.onBoardingModel});
  final OnboardingModel onBoardingModel;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          margin: EdgeInsets.fromLTRB(0, 0, 0, 1.h),
          child: Image.asset(onBoardingModel.imagePath),
        ),

        Text(
          onBoardingModel.title,
          textAlign: TextAlign.center,
          style: TextStyleHelper.textStylefontSize20.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        Text(
          textAlign: TextAlign.center,
          onBoardingModel.subtitle,
          style: TextStyleHelper.textStylefontSize16.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
