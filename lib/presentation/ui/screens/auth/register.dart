import 'package:eleaning/core/constant_text.dart';
import 'package:eleaning/core/helper/color_helper.dart';
import 'package:eleaning/core/helper/text_style_helper.dart';
import 'package:eleaning/core/utills/validator.dart';
import 'package:eleaning/extensions/media_query_extension.dart';
import 'package:eleaning/extensions/navigation_extension.dart';
import 'package:eleaning/presentation/cubit/register/register_cubit.dart';
import 'package:eleaning/presentation/cubit/register/register_state.dart';
import 'package:eleaning/presentation/cubit/user/user_cubit.dart';
import 'package:eleaning/presentation/ui/screens/auth/forget_password.dart';
import 'package:eleaning/presentation/ui/screens/auth/login.dart';

import 'package:eleaning/presentation/ui/widgets/common_widget/custom_elevated_button.dart';
import 'package:eleaning/presentation/ui/widgets/common_widget/custom_text_field.dart';
import 'package:eleaning/presentation/ui/widgets/common_widget/toast_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  bool isObsecurePass = true;
  bool isObsecureConfirmPass = true;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => RegistrationCubit()),
        BlocProvider(create: (context) => UserCubit()),
      ],
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.screenWidth / 50,
              vertical: context.screenHeight / 10,
            ),
            child: BlocConsumer<RegistrationCubit, RegistrationStatus>(
              listener: (context, state) {
                if (state is RegistrationSuccess) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                } else if (state is RegistrationFailure) {
                  CreateDialogToaster.showErrorToast(state.error);
                }
              },
              builder: (context, state) {
                return Form(
                  key: formState,
                  child: Center(
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

                        CustomTextField(
                          textLabel: ConstantText.username,
                          textController: usernameController,
                          textFieldSuffix: Icon(Icons.person_2_outlined),

                          validatorFunction: (value) {
                            Validators.checkIsEmpty(value);
                            return null;
                          },
                        ),
                        CustomTextField(
                          textLabel: ConstantText.fullName,
                          textController: fullNameController,
                          textFieldSuffix: Icon(Icons.person_2_outlined),

                          validatorFunction: (value) {
                            Validators.checkIsEmpty(value);
                            return null;
                          },
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
                        CustomTextField(
                          textLabel: ConstantText.confirmPassword,
                          textController: confirmPasswordController,
                          isObsecure: isObsecureConfirmPass,
                          keyboardType: TextInputType.visiblePassword,
                          textFieldSuffix: IconButton(
                            icon:
                                isObsecureConfirmPass
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
                                isObsecureConfirmPass = !isObsecureConfirmPass;
                              });
                            },
                          ),
                          validatorFunction: (value) {
                            passwordController.text != value
                                ? "password"
                                : null;
                            return null;
                          },
                        ),
                        SizedBox(height: 6.h),
                        CustomElevatedButton(
                          buttonText: ConstantText.register,
                          buttonColor: ColorHelper.blue,
                          textColor: ColorHelper.white,
                          onPressedFunction: () async {
                            if (formState.currentState!.validate()) {
                              await context
                                  .read<RegistrationCubit>()
                                  .registerWithEmailAndPassword(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  )
                                  .then((v) {
                                    // ignore: use_build_context_synchronously
                                    context.read<UserCubit>().addUser(
                                      userMail: emailController.text,
                                      fullName: fullNameController.text,
                                      userName: usernameController.text,
                                      userPassword: passwordController.text,
                                    );
                                  });
                            }
                          },
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          ConstantText.haveAccount,
                          style: TextStyleHelper.textStylefontSize18,
                        ),
                        SizedBox(height: 1.h),
                        TextButton(
                          onPressed: () {
                            context.push(LoginScreen());
                          },
                          child: Text(
                            ConstantText.forgetPassword,
                            style: TextStyleHelper.textStylefontSize18.copyWith(
                              color: ColorHelper.blue,
                            ),
                          ),
                        ),
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
