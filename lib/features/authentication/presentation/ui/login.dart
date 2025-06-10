import 'package:eleaning/core/constants/constant_text.dart';
import 'package:eleaning/core/helper/color_helper.dart';
import 'package:eleaning/core/helper/text_style_helper.dart';
import 'package:eleaning/core/utills/validator.dart';
import 'package:eleaning/core/extensions/media_query_extension.dart';
import 'package:eleaning/core/extensions/navigation_extension.dart';
import 'package:eleaning/features/authentication/presentation/cubit/login/login_cubit.dart';
import 'package:eleaning/features/authentication/presentation/cubit/login/login_state.dart';
import 'package:eleaning/features/authentication/presentation/ui/forget_password.dart';
import 'package:eleaning/features/home/presentation/ui/home_screen.dart';
import 'package:eleaning/shared/widget/custom_elevated_button.dart';
import 'package:eleaning/shared/widget/custom_text_field.dart';
import 'package:eleaning/shared/widget/toast_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  bool isObsecurePass = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: Scaffold(
        backgroundColor: ColorHelper.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.screenWidth / 50,
              vertical: context.screenHeight / 10,
            ),
            child: BlocConsumer<LoginCubit, LogInStatus>(
              listener: (context, state) {
                if (state is LoginSuccess) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                } else if (state is LoginFailure) {
                  CreateDialogToaster.showErrorToast(state.errorMessage);
                }
              },
              builder: (context, state) {
                return Form(
                  key: formState,
                  child: Column(
                    children: [
                      Text(
                        ConstantText.loginMessage,
                        style: TextStyleHelper.textStylefontSize24.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8.h),
                      CustomElevatedButton(
                        buttonText: ConstantText.loginGoogleButton,
                        buttonColor: ColorHelper.lightGrey,
                        textColor: ColorHelper.black,
                        buttonIcon: Image.asset("assets/images/google.png"),
                        onPressedFunction: () {
                          context.read<LoginCubit>().loginWithGoogle();
                        },
                      ),
                      SizedBox(height: 3.h),
                      CustomElevatedButton(
                        buttonText: ConstantText.loginFacebookButton,
                        buttonColor: ColorHelper.lightGrey,
                        textColor: ColorHelper.black,
                        buttonIcon: Image.asset("assets/images/facebook.png"),
                        onPressedFunction: () async {
                          await context.read<LoginCubit>().signInWithFacebook();
                        },
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        ConstantText.or,
                        style: TextStyleHelper.textStylefontSize16,
                        textAlign: TextAlign.center,
                      ),
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
                      CustomTextField(
                        textLabel: ConstantText.password,
                        textController: passwordController,
                        isObsecure: isObsecurePass,
                        keyboardType: TextInputType.visiblePassword,
                        textFieldSuffix: IconButton(
                          icon:
                              isObsecurePass
                                  ? Icon(
                                    Icons.visibility_off,
                                    color: ColorHelper.black,
                                  )
                                  : Icon(
                                    Icons.visibility,
                                    color: ColorHelper.black,
                                  ),
                          onPressed: () {
                            setState(() {
                              isObsecurePass = !isObsecurePass;
                            });
                          },
                        ),
                        validatorFunction: (value) {
                          Validators.validatePassword(value);
                          return null;
                        },
                      ),
                      SizedBox(height: 6.h),
                      CustomElevatedButton(
                        buttonText: ConstantText.login,
                        buttonColor: ColorHelper.blue,
                        textColor: ColorHelper.white,
                        onPressedFunction: () {
                          context.read<LoginCubit>().loginwithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text,
                            context: context,
                          );
                        },
                      ),
                      SizedBox(height: 1.h),
                      TextButton(
                        onPressed: () {
                          context.push(ForgetPassword());
                        },
                        child: Text(
                          ConstantText.forgetPassword,
                          style: TextStyleHelper.textStylefontSize18.copyWith(
                            color: ColorHelper.blue,
                          ),
                        ),
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
