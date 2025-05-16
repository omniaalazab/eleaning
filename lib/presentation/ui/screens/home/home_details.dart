import 'package:eleaning/core/constant_text.dart';
import 'package:eleaning/core/helper/color_helper.dart';
import 'package:eleaning/core/helper/text_style_helper.dart';
import 'package:eleaning/data/repository/most_watched_repository.dart';
import 'package:eleaning/data/repository/popular_category_repository.dart';
import 'package:eleaning/data/repository/teacher_repository.dart';
import 'package:eleaning/extensions/media_query_extension.dart';
import 'package:eleaning/presentation/cubit/most_watched/most_watched_cubit.dart';
import 'package:eleaning/presentation/cubit/most_watched/most_watched_state.dart';
import 'package:eleaning/presentation/cubit/popular_category/popular_category_cubit.dart';
import 'package:eleaning/presentation/cubit/popular_category/popular_category_state.dart';
import 'package:eleaning/presentation/cubit/teacher/teacher_cubit.dart';
import 'package:eleaning/presentation/cubit/teacher/teacher_state.dart';
import 'package:eleaning/presentation/cubit/user/user_cubit.dart';
import 'package:eleaning/presentation/cubit/user/user_state.dart';
import 'package:eleaning/presentation/ui/widgets/common_widget/custom_text_field.dart';
import 'package:eleaning/presentation/ui/widgets/popular_category_row.dart';
import 'package:eleaning/presentation/ui/widgets/star_rating_row.dart';
import 'package:eleaning/presentation/ui/widgets/user_info_user.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

class HomeDetails extends StatefulWidget {
  const HomeDetails({super.key});

  @override
  State<HomeDetails> createState() => _HomeDetailsState();
}

class _HomeDetailsState extends State<HomeDetails> {
  final PopularCategoryRepository popularCategoryRepository =
      PopularCategoryRepository();
  final MostWatchedRepository mostWatchedRepository = MostWatchedRepository();
  final TeacherRepository teacherRepository = TeacherRepository();
  final TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    context.read<UserCubit>().fetchUserData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  PopularCategoryCubit(popularCategoryRepository)
                    ..getPopularCategory(),
        ),
        BlocProvider(
          create:
              (context) =>
                  MostWatchedCubit(mostWatchedRepository)..getMostWatched(),
        ),
        BlocProvider(
          create:
              (context) =>
                  TeacherCubit(teacherRepository: teacherRepository)
                    ..getTeacher(),
        ),
      ],

      child: Scaffold(
        backgroundColor: ColorHelper.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 5.w,
              vertical: context.screenHeight / 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<UserCubit, UserState>(
                  builder: (context, state) {
                    if (state.user.isEmpty) {
                      return CircularProgressIndicator();
                    }
                    return UserInfoRow(
                      userName: state.user[0].userName,
                      userImagePath: state.user[0].userImagePath,
                    );
                  },
                ),
                CustomTextField(
                  textLabel: ConstantText.graphicIllustration,
                  textController: searchController,
                  textFieldSuffix: SvgPicture.asset(
                    "assets/images/Search - liniar.svg",
                  ),
                  validatorFunction: (value) {
                    return null;
                  },
                ),
                SizedBox(height: 1.h),
                Text(
                  ConstantText.popularCourse,
                  style: TextStyleHelper.textStylefontSize22.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 3.h),
                SizedBox(
                  // height: 10.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocBuilder<PopularCategoryCubit, PopularCategoryStatus>(
                        builder: (context, state) {
                          if (state is PopularCategoryLoading) {
                            return CircularProgressIndicator();
                          } else if (state is PopularCategorySucess) {
                            return SizedBox(
                              height: 25.h,
                              // width: 90.w,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: state.popularCategories.length,
                                itemBuilder: (context, index) {
                                  return PopularCategoryRow(
                                    popularCategoryImagePath:
                                        state
                                            .popularCategories[index]
                                            .categoryImage,
                                    categoryTitle:
                                        state
                                            .popularCategories[index]
                                            .categoryTitle,
                                  );
                                },
                              ),
                            );
                          } else {
                            return Text(ConstantText.error);
                          }
                        },
                      ),
                      // SizedBox(height: 1.h),
                      Text(
                        ConstantText.mostWatching,
                        style: TextStyleHelper.textStylefontSize22,
                      ),
                      SizedBox(height: 3.h),
                      BlocBuilder<MostWatchedCubit, MostWatchedStatus>(
                        builder: (context, state) {
                          if (state is MostWatchedLoading) {
                            return CircularProgressIndicator();
                          } else if (state is MostWatchedFailure) {
                            return Text(state.message);
                          } else if (state is MostWatchedSucess) {
                            return SizedBox(
                              height: 40.h,
                              // width: 90.w,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: state.mostWatchedModel.length,
                                itemBuilder: (context, index) {
                                  return MostWatchedRow(
                                    mostWatchedImagePath:
                                        state.mostWatchedModel[index].imagePath,
                                    courseTitle:
                                        state
                                            .mostWatchedModel[index]
                                            .courseTitle,
                                    teacherName:
                                        state
                                            .mostWatchedModel[index]
                                            .teacherName,
                                    rate: state.mostWatchedModel[index].rate,
                                    watchedNumber:
                                        state
                                            .mostWatchedModel[index]
                                            .watchedNumber,
                                  );
                                },
                              ),
                            );
                          } else {
                            return Text(ConstantText.error);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  ConstantText.popularTeacher,
                  style: TextStyleHelper.textStylefontSize22.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 2.h),
                BlocBuilder<TeacherCubit, TeacherState>(
                  builder: (context, state) {
                    if (state is TeacherLoading) {
                      return CircularProgressIndicator();
                    } else if (state is TeacherFailure) {
                      return Text(state.error);
                    } else if (state is TeacherSucess) {
                      return SizedBox(
                        height: 30.h,
                        // width: 43.w,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.teacher.length,
                          itemBuilder: (context, index) {
                            return TeacherInfoRow(
                              imagePath: state.teacher[index].imagePath,
                              teacherJob: state.teacher[index].jobTitle,
                              teacherName: state.teacher[index].teacherName,
                            );
                          },
                        ),
                      );
                    } else {
                      return Text(ConstantText.error);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TeacherInfoRow extends StatelessWidget {
  const TeacherInfoRow({
    super.key,
    required this.imagePath,
    required this.teacherJob,
    required this.teacherName,
  });
  final String imagePath;
  final String teacherName;
  final String teacherJob;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 43.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 40.w,
                height: 22.h,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 10.h,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(
                            imagePath,
                            height: 20.h,
                            width: 30.w,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      // ),
                    ),
                  ],
                ),
              ),
              Text(teacherName, style: TextStyleHelper.textStylefontSize18),
              Text(
                teacherJob,
                style: TextStyleHelper.textStylefontSize14.copyWith(
                  color: ColorHelper.grey1,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 2),
      ],
    );
  }
}

class MostWatchedRow extends StatelessWidget {
  const MostWatchedRow({
    super.key,
    required this.mostWatchedImagePath,
    required this.courseTitle,
    required this.teacherName,
    required this.rate,
    required this.watchedNumber,
  });
  final String mostWatchedImagePath;
  final String courseTitle;
  final String teacherName;
  final double rate;
  final int watchedNumber;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 43.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: Image.network(
                      mostWatchedImagePath,
                      height: 20.h,
                      width: 50.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      width: 15.w,
                      decoration: BoxDecoration(color: ColorHelper.darkOrange),
                      child: Center(child: Text(ConstantText.hot)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Text(
                courseTitle,
                style: TextStyleHelper.textStylefontSize18.copyWith(
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 2,
              ),
              Text(
                teacherName,
                style: TextStyleHelper.textStylefontSize14.copyWith(
                  color: ColorHelper.lightGrey,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$rate',
                    style: TextStyleHelper.textStylefontSize14.copyWith(
                      color: ColorHelper.lightGrey,
                    ),
                  ),
                  CustomRatingBar(rating: rate, ratingCount: 5),
                  Spacer(),
                  Text(
                    '{$watchedNumber}',
                    style: TextStyleHelper.textStylefontSize14.copyWith(
                      color: ColorHelper.lightGrey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(width: 4.w),
      ],
    );
  }
}
