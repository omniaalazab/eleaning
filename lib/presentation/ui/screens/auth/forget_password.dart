import 'package:eleaning/core/constant_text.dart';
import 'package:eleaning/core/helper/color_helper.dart';
import 'package:eleaning/core/helper/text_style_helper.dart';
import 'package:eleaning/core/utills/validator.dart';
import 'package:eleaning/extensions/media_query_extension.dart';
import 'package:eleaning/extensions/navigation_extension.dart';
import 'package:eleaning/presentation/cubit/reset/reset_cubit.dart';
import 'package:eleaning/presentation/cubit/reset/reset_state.dart';
import 'package:eleaning/presentation/ui/screens/auth/send_mail_reset.dart';
import 'package:eleaning/presentation/ui/widgets/common_widget/custom_elevated_button.dart';
import 'package:eleaning/presentation/ui/widgets/common_widget/custom_text_field.dart';
import 'package:eleaning/presentation/ui/widgets/common_widget/toast_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController emailController = TextEditingController();

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetCubit(),
      child: Scaffold(
        backgroundColor: ColorHelper.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.screenWidth / 20,
              vertical: context.screenHeight / 10,
            ),
            child: BlocConsumer<ResetCubit, ResetStatus>(
              listener: (context, state) {
                if (state is ResetSuccess) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SendMailForReset(),
                    ),
                  );
                } else if (state is ResetFailure) {
                  CreateDialogToaster.showErrorToast(state.errorMessage);
                }
              },
              builder: (context, state) {
                return Form(
                  key: formState,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          context.pop();
                        },
                        icon: Icon(Icons.arrow_back_ios_new_rounded),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        ConstantText.enterEmaail,
                        style: TextStyleHelper.textStylefontSize20.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.h),

                      CustomTextField(
                        textLabel: ConstantText.email,
                        textController: emailController,
                        textFieldSuffix: Icon(Icons.email),
                        keyboardType: TextInputType.emailAddress,
                        validatorFunction: (value) {
                          Validators.validateEmail(value);
                          return null;
                        },
                      ),

                      SizedBox(height: 6.h),
                      CustomElevatedButton(
                        buttonText: ConstantText.sentMail,
                        buttonColor: ColorHelper.blue,
                        textColor: ColorHelper.white,
                        onPressedFunction: () {
                          context.read<ResetCubit>().resetPassword(
                            emailController.text,
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
