// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skiive/features/authentication/screens/courseDetails/course_section.dart';
import 'package:skiive/models/my_courses_model.dart';
import 'package:skiive/utils/constants/section_heading.dart';
import 'package:skiive/utils/theme/constantThemes/card.dart';

import '../../../../models/all_courses_model.dart';
import '../../../../utils/http/api.dart';
import '../../../../utils/loaders/loaders.dart';
import '../../../../utils/theme/constantThemes/my_courses_card.dart';
import '../courseDetails/details_screen.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String? studentId;
  String? token;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      studentId = prefs.getString('parameterId');
      token = prefs.getString('accessToken');
    });
  }

  Future<List<MyCoursesModel>> getMyCourses() async {
    var coursesUrl = Uri.parse(
        "https://emerge-lms-api.onrender.com/api/v1/course-manager/paid/$studentId");
    final response = await http.get(coursesUrl, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    var coursesData = json.decode(response.body);
    final List body = coursesData['data']['courseManager'];

    return body.map((e) => MyCoursesModel.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const BackButton(
          color: Colors.blueAccent,
        ),
        title: Text(
          'My Courses',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 25),
          child: Column(
            children: [
              FutureBuilder<List<MyCoursesModel>>(
                future:
                    getMyCourses(), // Replace fetchCourses() with your function to fetch the courses data
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error fetching courses'));
                  } else {
                    List<MyCoursesModel> courses = snapshot.data!;
                    // Display your courses using ListView, GridView, or any other widget
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: GridView.builder(
                                itemCount: courses.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 30,
                                        crossAxisSpacing: 15,
                                        mainAxisExtent: 220),
                                itemBuilder: (context, index) =>
                                    GestureDetector(
                                        onTap: () {
                                          Get.to(() => CourseSection(
                                                name:
                                                    courses[index].course.name,
                                                contentId: courses[index]
                                                    .course
                                                    .content,
                                              ));
                                        },
                                        child: MyCoursesCard(
                                          // ignore: unnecessary_string_interpolations
                                          id: courses[index].course.content,
                                          image: courses[index].course.image,
                                          name: courses[index].course.name,
                                        ))),
                          )
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
