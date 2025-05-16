import 'package:eleaning/core/constant_text.dart';
import 'package:eleaning/core/helper/color_helper.dart';
import 'package:eleaning/core/helper/text_style_helper.dart';
import 'package:eleaning/extensions/navigation_extension.dart';
import 'package:eleaning/presentation/cubit/profile/profile_cubit.dart';
import 'package:eleaning/presentation/cubit/profile/profile_state.dart';
import 'package:eleaning/presentation/cubit/signout/signout_cubit.dart';
import 'package:eleaning/presentation/cubit/user/user_cubit.dart';
import 'package:eleaning/presentation/cubit/user/user_state.dart';
import 'package:eleaning/presentation/ui/screens/auth/login.dart';
import 'package:eleaning/presentation/ui/screens/student/edit_profile.dart';
import 'package:eleaning/presentation/ui/widgets/common_widget/custom_elevated_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sizer/sizer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Check if user is logged in before trying to fetch data
      if (FirebaseAuth.instance.currentUser != null) {
        context.read<UserCubit>().fetchUserData();
        context.read<ProfileCubit>().fetchProfileImage(context);
      }
    });
  }

  // final profileCubit = context.read<ProfileCubit>();
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state.user.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 20.h,
                      decoration: BoxDecoration(color: ColorHelper.red),
                    ),

                    Positioned(
                      top: 13.h,
                      left: 35.w,
                      //right: 4.w,
                      child: Stack(
                        children: [
                          InkWell(
                            onTap: () {
                              context.push(const EditProfile());
                              context.read<ProfileCubit>().changeProfileImage(
                                context,
                              );
                            },
                            child: BlocBuilder<ProfileCubit, ProfileState>(
                              builder: (context, state) {
                                // Handle different profile states
                                if (state is LoadingProfileState) {
                                  return const CircleAvatar(
                                    radius: 50,
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state is SucessProfileState) {
                                  // Display profile image with MemoryImage from state
                                  return CircleAvatar(
                                    radius: 50,
                                    backgroundImage: state.imageProvider,
                                  );
                                } else if (state is FailureProfileState) {
                                  return const CircleAvatar(
                                    radius: 50,
                                    child: Icon(Icons.error),
                                  );
                                } else {
                                  // Default placeholder
                                  return const CircleAvatar(
                                    radius: 50,
                                    child: Icon(Icons.person),
                                  );
                                }
                              },
                            ),
                          ),

                          Positioned(
                            left: 60,
                            bottom: 0,
                            child: CircleAvatar(
                              radius: 20,
                              child: IconButton(
                                onPressed: () {
                                  context
                                      .read<ProfileCubit>()
                                      .changeProfileImage(context);
                                },
                                icon: Icon(Icons.edit),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Positioned(
                      top: 25.h,
                      left: 0,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 2.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                text: "${ConstantText.username} : ",
                                style: TextStyleHelper.textStylefontSize16
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: ColorHelper.red,
                                    ),
                                children: [
                                  TextSpan(
                                    text: state.user[0].userName,
                                    style: TextStyleHelper.textStylefontSize18
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text.rich(
                              TextSpan(
                                text: "${ConstantText.fullName} :  ",
                                style: TextStyleHelper.textStylefontSize16
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: ColorHelper.red,
                                    ),
                                children: [
                                  TextSpan(
                                    text: state.user[0].userFullName,
                                    style: TextStyleHelper.textStylefontSize18
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text.rich(
                              TextSpan(
                                text: "${ConstantText.email} : ",
                                style: TextStyleHelper.textStylefontSize16
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: ColorHelper.red,
                                    ),
                                children: [
                                  TextSpan(
                                    text: state.user[0].userMail,
                                    style: TextStyleHelper.textStylefontSize18
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              ConstantText.shareProfile,
                              style: TextStyleHelper.textStylefontSize18
                                  .copyWith(
                                    color: ColorHelper.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            SizedBox(height: 20),
                            Center(
                              child: QrImageView(
                                data: "",
                                version: QrVersions.auto,
                                size: 200.0,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              ConstantText.scanQRCode,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 3.h),
                            BlocProvider(
                              create: (context) => SignOutCubit(),
                              child: TextButton(
                                onPressed: () {
                                  context.read<SignOutCubit>().signOut();
                                  context.pushRemoveUntil(LoginScreen());
                                },
                                child: Text(
                                  ConstantText.logout,
                                  style: TextStyleHelper.textStylefontSize18
                                      .copyWith(color: ColorHelper.red),
                                ),
                              ),
                            ),
                            // CustomElevatedButton(
                            //   buttonText: ConstantText.logout,
                            //   onPressedFunction: () {
                            //     context.read<UserCubit>().signOut();
                            //   },
                            //   buttonColor: ColorHelper.red,
                            //   textColor: ColorHelper.white,
                            //   widthButton: 40.w,
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
