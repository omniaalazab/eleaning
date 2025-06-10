import 'package:eleaning/core/constants/constant_text.dart';
import 'package:eleaning/core/helper/color_helper.dart';
import 'package:eleaning/core/helper/text_style_helper.dart';
import 'package:eleaning/core/utills/validator.dart';
import 'package:eleaning/core/extensions/navigation_extension.dart';
import 'package:eleaning/features/profile/presentation/cubit/profile/profile_cubit.dart';
import 'package:eleaning/features/profile/presentation/cubit/profile/profile_state.dart';
import 'package:eleaning/features/authentication/presentation/cubit/user/user_cubit.dart';
import 'package:eleaning/features/authentication/presentation/cubit/user/user_state.dart';
import 'package:eleaning/features/profile/presentation/ui/profile.dart';
import 'package:eleaning/shared/widget/custom_elevated_button.dart';
import 'package:eleaning/shared/widget/custom_text_field.dart';
import 'package:eleaning/shared/widget/toast_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController fullNameController = TextEditingController();

  TextEditingController userNameController = TextEditingController();

  TextEditingController mailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController phoneController = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  User? user = FirebaseAuth.instance.currentUser;
  bool isObsecurePass = true;
  @override
  void initState() {
    context.read<ProfileCubit>().fetchProfileImage(context);
    if (user != null) {
      mailController.text = user!.email ?? '';
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorHelper.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
        title: Text(
          ConstantText.editProfile,
          style: TextStyleHelper.textStylefontSize20.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 30, 15, 30),
          child: Column(
            children: [
              // Profile Image Section
              Stack(
                children: [
                  BlocConsumer<ProfileCubit, ProfileState>(
                    listener: (context, state) {
                      if (state is FailureProfileState) {
                        CreateDialogToaster.showErrorToast(
                          ConstantText.oopsError,
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is SucessProfileState) {
                        return InkWell(
                          onTap: () {
                            context.read<ProfileCubit>().changeProfileImage(
                              context,
                            );
                          },
                          child: CircleAvatar(
                            backgroundImage: state.imageProvider,
                            radius: 50,
                          ),
                        );
                      }
                      return InkWell(
                        onTap: () {
                          context.read<ProfileCubit>().changeProfileImage(
                            context,
                          );
                        },
                        child: const CircleAvatar(
                          backgroundImage: AssetImage(
                            "assets/images/Profile.png",
                          ),
                          radius: 50,
                        ),
                      );
                    },
                  ),
                  Positioned(
                    left: 60,
                    bottom: 0,
                    child: InkWell(
                      onTap: () {
                        context.read<ProfileCubit>().changeProfileImage(
                          context,
                        );
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: ColorHelper.white,
                        child: const Icon(Icons.camera_enhance_outlined),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Form Section
              Form(
                key: formState,
                child: BlocBuilder<UserCubit, UserState>(
                  builder: (context, state) {
                    if (state.user.isNotEmpty) {
                      return Column(
                        children: [
                          CustomTextField(
                            textController: userNameController,
                            textLabel: ConstantText.username,
                            textFieldSuffix: Icon(
                              Icons.person_outline_rounded,
                              color: ColorHelper.grey,
                            ),
                            validatorFunction: (value) {
                              Validators.checkIsEmpty(value);
                              // CheckEmptyValidationTextField.checkIsEmpty(value);
                              return null;
                            },
                          ),
                          CustomTextField(
                            textController: mailController,
                            textLabel: ConstantText.email,
                            textFieldSuffix: Icon(
                              Icons.mail_outlined,
                              color: ColorHelper.grey,
                            ),
                            validatorFunction: (value) {
                              Validators.validateEmail(value);
                              return null;
                            },
                          ),

                          CustomTextField(
                            textController: passwordController,
                            textLabel: ConstantText.password,
                            isObsecure: isObsecurePass,
                            textFieldSuffix: IconButton(
                              icon:
                                  isObsecurePass
                                      ? Icon(
                                        Icons.visibility_off,
                                        color: ColorHelper.grey,
                                      )
                                      : Icon(
                                        Icons.visibility,
                                        color: ColorHelper.grey,
                                      ),
                              onPressed: () {
                                setState(() {
                                  isObsecurePass = !isObsecurePass;
                                });
                              },
                            ),
                            validatorFunction: (value) {
                              if (value!.length < 8) {
                                return ConstantText.passwordCharacters;
                              }
                              // CheckEmptyValidationTextField.checkIsEmpty(value);
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          CustomElevatedButton(
                            buttonText: ConstantText.confirm,
                            onPressedFunction: () async {
                              if (formState.currentState!.validate()) {
                                try {
                                  await context.read<UserCubit>().updateUser(
                                    userMail: mailController.text,

                                    userName: userNameController.text,
                                    userPassword: passwordController.text,
                                    profileImage: state.user[0].userImagePath,
                                  );
                                  // ignore: use_build_context_synchronously
                                  context.push(ProfileScreen());
                                } catch (e) {
                                  CreateDialogToaster.showErrorToast(
                                    ConstantText.failedtoupdateprofile,
                                  );
                                }
                              }
                            },
                          ),
                        ],
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
