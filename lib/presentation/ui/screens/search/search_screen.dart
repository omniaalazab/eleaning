import 'dart:developer';

import 'package:eleaning/core/constant_text.dart';
import 'package:eleaning/core/helper/color_helper.dart';
import 'package:eleaning/core/helper/text_style_helper.dart';
import 'package:eleaning/data/models/course_model.dart';
import 'package:eleaning/data/repository/courses_repository.dart';
import 'package:eleaning/data/repository/popular_category_repository.dart';
import 'package:eleaning/data/services/stripe_payment/payment_manager.dart';
import 'package:eleaning/extensions/navigation_extension.dart';
import 'package:eleaning/presentation/cubit/payment/payment_cubit.dart';
import 'package:eleaning/presentation/cubit/payment/payment_state.dart';
import 'package:eleaning/presentation/cubit/popular_category/popular_category_cubit.dart';
import 'package:eleaning/presentation/cubit/popular_category/popular_category_state.dart';
import 'package:eleaning/presentation/cubit/search/search_cubit.dart';
import 'package:eleaning/presentation/cubit/search/search_state.dart';
import 'package:eleaning/presentation/ui/screens/courses/course_screen.dart';
import 'package:eleaning/presentation/ui/widgets/common_widget/custom_text_field.dart';
import 'package:eleaning/presentation/ui/widgets/popular_category_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  final PopularCategoryRepository popularCategoryRepository =
      PopularCategoryRepository();
  final CoursesRepository coursesRepository = CoursesRepository();
  late SearchCubit searchCubit;
  @override
  void initState() {
    super.initState();

    searchCubit = SearchCubit(coursesRepository);
    searchController.addListener(onChange);
    searchCubit.getFirestoreDocuments();
    log("**************************************");
  }

  void onChange() {
    log(searchController.text);
    if (searchController.text.isEmpty) {
      searchCubit.clearSearch();
    } else {
      searchCubit.searchResultList(searchController.text);
    }
  }

  @override
  void dispose() {
    searchController.removeListener(onChange);
    searchController.dispose();
    super.dispose();
  }

  String searchTerm = '';
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
                  SearchCubit(coursesRepository)..getFirestoreDocuments(),
        ),
      ],

      child: Scaffold(
        backgroundColor: ColorHelper.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search bar section
                CustomTextField(
                  textLabel: ConstantText.graphicIllustration,
                  textController: searchController,
                  textFieldSuffix: InkWell(
                    child: SvgPicture.asset(
                      "assets/images/Search - liniar.svg",
                    ),
                    onTap: () {
                      searchCubit.searchResultList(searchController.text);
                    },
                  ),
                  validatorFunction: (value) {
                    return null;
                  },
                ),
                SizedBox(height: 2.h),

                // Search results section
                Expanded(
                  child: BlocProvider(
                    create: (context) => searchCubit,
                    child: BlocBuilder<SearchCubit, SearchCoursesState>(
                      builder: (context, state) {
                        if (state is SearchCoursesLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is SearchCoursesSucesss &&
                            searchController.text.isNotEmpty) {
                          final courses = state.courses;
                          return courses.isEmpty
                              ? Center(child: Text(ConstantText.noCourse))
                              : _buildSearchResults(courses);
                        } else if (state is SearchCoursesFailure &&
                            searchController.text.isNotEmpty) {
                          return Center(child: Text(state.error));
                        } else {
                          return _beforeSearchColumn();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults(List<CourseModel> courses) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ConstantText.searchResult,
          style: TextStyleHelper.textStylefontSize16,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return BlocProvider(
                create: (_) => PaymentCubit(),
                child: BlocConsumer<PaymentCubit, PaymentState>(
                  listener: (context, state) {
                    if (state is PaymentSucess) {
                      context.push(CourseScreen(courseModel: course));
                    } else if (state is PaymentFailure) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.error)));
                    }
                  },
                  builder: (context, state) {
                    return InkWell(
                      onTap: () {
                        if (course.isPaid == true) {
                          context.push(CourseScreen(courseModel: course));
                        } else {
                          context.read<PaymentCubit>().makePayment(
                            courseId: course.id,
                            amount: course.amount,
                            currency: "USD",
                          );
                        }
                      },
                      child:
                          state is PaymentLoading
                              ? const CircularProgressIndicator()
                              : Text("Access Course"),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _beforeSearchColumn() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 2.h),
          Text(
            ConstantText.topsearches,
            style: TextStyleHelper.textStylefontSize16,
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _topSearchContainer(titleTopSearch: ConstantText.photography),
              _topSearchContainer(titleTopSearch: ConstantText.craft),
              _topSearchContainer(titleTopSearch: ConstantText.art),
            ],
          ),
          Row(
            children: [
              _topSearchContainer(titleTopSearch: ConstantText.procreate),
              _topSearchContainer(titleTopSearch: ConstantText.marketing),
            ],
          ),
          _topSearchContainer(titleTopSearch: ConstantText.uxdesign),
          SizedBox(height: 2.h),
          Text(
            ConstantText.categories,
            style: TextStyleHelper.textStylefontSize16,
          ),
          // SizedBox(height: 1.h),
          BlocBuilder<PopularCategoryCubit, PopularCategoryStatus>(
            builder: (context, state) {
              if (state is PopularCategoryLoading) {
                return CircularProgressIndicator();
              } else if (state is PopularCategoryFailure) {
                return Text(state.message);
              } else if (state is PopularCategorySucess) {
                return SizedBox(
                  height: 100.h,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2.9 / 3,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                    ),
                    itemCount: state.popularCategories.length,
                    itemBuilder: (context, index) {
                      return PopularCategoryRow(
                        categoryTitle:
                            state.popularCategories[index].categoryTitle,
                        popularCategoryImagePath:
                            state.popularCategories[index].categoryImage,
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
    );
  }

  Widget _topSearchContainer({required String titleTopSearch}) {
    return Container(
      margin: EdgeInsets.only(right: 2.w, top: 1.h),
      decoration: BoxDecoration(
        color: ColorHelper.greyLight,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 10),

        child: Text(
          titleTopSearch,
          style: TextStyleHelper.textStylefontSize16.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
