import 'package:eleaning/core/helper/color_helper.dart';
import 'package:eleaning/extensions/navigation_extension.dart';
import 'package:eleaning/presentation/cubit/profile/profile_cubit.dart';
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
    context.read<UserCubit>().fetchUserData();
    context.read<ProfileCubit>().fetchProfileImage(context);
    super.initState();
  }

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
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: ColorHelper.white,

                              backgroundImage: NetworkImage(
                                (state.user[0].userImagePath),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 60,
                            bottom: 0,
                            child: CircleAvatar(
                              radius: 20,
                              child: IconButton(
                                onPressed: () {},
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
                          children: [
                            Text(
                              "Username",
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
