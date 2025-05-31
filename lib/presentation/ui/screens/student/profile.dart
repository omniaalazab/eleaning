import 'dart:developer';

import 'package:eleaning/core/constant_text.dart';
import 'package:eleaning/core/helper/color_helper.dart';
import 'package:eleaning/core/helper/text_style_helper.dart';
import 'package:eleaning/extensions/navigation_extension.dart';
import 'package:eleaning/presentation/cubit/profile/profile_cubit.dart';
import 'package:eleaning/presentation/cubit/profile/profile_state.dart';
import 'package:eleaning/presentation/cubit/signout/signout_cubit.dart';
import 'package:eleaning/presentation/cubit/signout/signout_state.dart';
import 'package:eleaning/presentation/cubit/user/user_cubit.dart';
import 'package:eleaning/presentation/cubit/user/user_state.dart';
import 'package:eleaning/presentation/ui/screens/auth/login.dart';
import 'package:eleaning/presentation/ui/screens/student/edit_profile.dart';
import 'package:eleaning/presentation/ui/widgets/common_widget/custom_elevated_button.dart';
import 'package:eleaning/presentation/ui/widgets/common_widget/toast_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sizer/sizer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoutAnimation;
  late SignOutCubit _signOutCubit;

  @override
  void initState() {
    super.initState();
    _logoutAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _signOutCubit = SignOutCubit();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Check if user is logged in before trying to fetch data
      if (FirebaseAuth.instance.currentUser != null) {
        context.read<UserCubit>().fetchUserData();
        context.read<ProfileCubit>().fetchProfileImage(context);
      }
    });
  }

  @override
  void dispose() {
    _logoutAnimation.dispose();
    _signOutCubit.close();
    super.dispose();
  }

  void _handleSignOut() {
    log("Sign out button pressed");

    showDialog(
      barrierDismissible: false,
      context: context,
      builder:
          (dialogContext) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: BlocProvider.value(
              value: _signOutCubit,
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
                        controller: _logoutAnimation,
                        repeat: false,
                        onLoaded: (composition) {
                          // Set the animation duration based on the Lottie file
                          _logoutAnimation.duration = composition.duration;

                          // Start the animation
                          _logoutAnimation.forward().then((_) {
                            // After animation completes, start the sign out process
                            _signOutCubit.signOut();
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
                                if (state is LoadingProfileState) {
                                  return const CircleAvatar(
                                    radius: 50,
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state is SucessProfileState) {
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
                                icon: const Icon(Icons.edit),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 25.h,
                      left: 0,
                      right: 0,
                      // bottom: 70.h,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 2.h,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // User Info sections (username, fullname, email)
                              _buildUserInfoSection(
                                "${ConstantText.username} : ",
                                state.user[0].userName,
                              ),
                              SizedBox(height: 2.h),
                              _buildUserInfoSection(
                                "${ConstantText.fullName} : ",
                                state.user[0].userFullName,
                              ),
                              SizedBox(height: 2.h),
                              _buildUserInfoSection(
                                "${ConstantText.email} : ",
                                state.user[0].userMail,
                              ),
                              SizedBox(height: 2.h),

                              // Share Profile Section
                              Text(
                                ConstantText.shareProfile,
                                style: TextStyleHelper.textStylefontSize18
                                    .copyWith(
                                      color: ColorHelper.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 20),
                              Center(
                                child: QrImageView(
                                  data: "", // Add actual QR data here
                                  version: QrVersions.auto,
                                  size: 200.0,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                ConstantText.scanQRCode,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 3.h),

                              // Logout Button
                            ],
                          ),
                        ),
                      ),
                    ),
                    // SizedBox(height: 60.h),
                    Positioned(
                      bottom: 2.h,
                      right: 4.w,
                      child: TextButton(
                        onPressed: () {
                          _handleSignOut();
                        },
                        child: Text(
                          ConstantText.logout,
                          style: TextStyleHelper.textStylefontSize18.copyWith(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildUserInfoSection(String label, String value) {
    return Text.rich(
      TextSpan(
        text: label,
        style: TextStyleHelper.textStylefontSize16.copyWith(
          fontWeight: FontWeight.bold,
          color: ColorHelper.red,
        ),
        children: [
          TextSpan(
            text: value,
            style: TextStyleHelper.textStylefontSize18.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
