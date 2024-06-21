// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_project/src/config/manager/storage_manager.dart';
import 'package:demo_project/src/config/theme/app_colors.dart';
import 'package:demo_project/src/config/theme/app_text_style.dart';
import 'package:demo_project/src/model/courses_model.dart';
import 'package:demo_project/src/module/courses/courses_model.dart';
import 'package:demo_project/src/module/courses/courses_presenter.dart';
import 'package:demo_project/src/module/courses/courses_view.dart';
import 'package:demo_project/src/module/sign_in/sign_in_screen.dart';
import 'package:demo_project/src/widgets/input_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;

import '../../constants/app_storage_key.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> implements CoursesView {
  late CoursesScreeenModel model;
    CoursesPresenter presenter = BasicCoursesPresenter();
  List<CoursesModel>? coursesList;
  List<CoursesModel>? searchCoursesList;
  ScrollController? scrollController;
  bool isAPICalling = true;
  int count = 5;

  @override
  void initState() {
    super.initState();
    presenter.signInView = this;
    fetchData();
    scrollController = ScrollController();
    scrollController!.addListener(_onScroll);
  }

  @override
  void refreshModel(CoursesScreeenModel signUpModel) {
    if (mounted) {
      setState(() {
        model = signUpModel;
      });
    }
  }

  Future<void> fetchData() async {
    setState(() {
      isAPICalling = true;
    });
    http.Response response = await http
        .get(Uri.parse('https://fakestoreapi.com/products?limit=$count'));

    coursesList = [];

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      for (var e in data) {
        coursesList!.add(CoursesModel.fromJson(e));
      }
    }
    searchCoursesList = coursesList;
    setState(() {
      isAPICalling = false;
    });
  }

  Future<void> onSearch(String? value) async {
    if (value == null || value.isEmpty) {
      setState(() {
        searchCoursesList = coursesList;
      });
      return;
    }
    searchCoursesList = coursesList!
        .where((element) =>
            element.title!.toLowerCase().contains(value.toLowerCase()) ||
            element.description!.toLowerCase().contains(value.toLowerCase()))
        .toList();
    setState(() {});
  }

  void _onScroll() {
    if (scrollController!.position.pixels ==
        scrollController!.position.maxScrollExtent) {
      count += 5;
      fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: const SizedBox(),
        centerTitle: true,
        title: Text(
          'DashBoard',
          style: AppTextStyle.regularText20.copyWith(
            fontFamily: 'poppins',
            color: AppColors.whiteColor,
          ),
        ),
        actions: [
          InkWell(
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              StorageManager.setBoolValue(
                  key: AppStorageKey.isLogIn, value: false);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const SignInScreen()),
                  (route) => false);
            },
            child: const Icon(Icons.power_settings_new_rounded),
          ),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormFieldWidget(
                  hintText: 'Search',
                  onChanged: (value) {
                    onSearch(value);
                  },
                  prefixIcon: const Icon(Icons.search_rounded),
                ),
                const SizedBox(
                  height: 12,
                ),
                if (searchCoursesList != null)
                  Text(
                    'Showing ${searchCoursesList?.length} Courses',
                    style: AppTextStyle.regularText14,
                  ),
                const SizedBox(
                  height: 12,
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: searchCoursesList?.length ?? 0,
                    physics: const BouncingScrollPhysics(),
                    controller: scrollController,
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                        height: 12,
                      );
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 130,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 80,
                              decoration: BoxDecoration(
                                color: AppColors.secondary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: searchCoursesList?[index].image ?? '',
                                placeholder: (context, url) => const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ],
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Flexible(
                                    child: Text(
                                      searchCoursesList?[index].title ?? '',
                                      style: AppTextStyle.regularText14,
                                      // maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    searchCoursesList?[index].description ?? '',
                                    style: AppTextStyle.regularText12.copyWith(
                                      color: Colors.grey,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Row(
                                    children: [
                                      RatingBar.builder(
                                        initialRating: searchCoursesList?[index]
                                                .rating
                                                ?.rate ??
                                            0,
                                        minRating: 0,
                                        itemSize: 18,
                                        updateOnDrag: false,
                                        tapOnlyMode: false,
                                        ignoreGestures: true,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemPadding: EdgeInsets.zero,
                                        unratedColor: AppColors.secondary,
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {},
                                      ),
                                      const SizedBox(
                                        width: 6,
                                      ),
                                      Text(
                                        '(${searchCoursesList?[index].rating!.rate.toString()})',
                                        style: AppTextStyle.lightText12,
                                      ),
                                      const SizedBox(
                                        width: 6,
                                      ),
                                      Text(
                                        '(${searchCoursesList?[index].rating!.count.toString()})',
                                        style: AppTextStyle.lightText12,
                                      ),
                                      const Spacer(),
                                      Text(
                                        '\$${searchCoursesList?[index].price}}',
                                        style: AppTextStyle.regularText16,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
            if (isAPICalling)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
