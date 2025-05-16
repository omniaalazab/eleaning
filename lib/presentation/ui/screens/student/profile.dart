import 'package:eleaning/core/helper/color_helper.dart';
import 'package:eleaning/extensions/navigation_extension.dart';
import 'package:eleaning/presentation/cubit/profile/profile_cubit.dart';
import 'package:eleaning/presentation/cubit/profile/profile_state.dart';
import 'package:eleaning/presentation/cubit/user/user_cubit.dart';
import 'package:eleaning/presentation/cubit/user/user_state.dart';
import 'package:eleaning/presentation/ui/screens/student/edit_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                            Text(
                              "User Name : ${state.user[0].userName}",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "User Full Name : ${state.user[0].userFullName}",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "User Mail : ${state.user[0].userMail}",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
