// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skiive/features/authentication/screens/courseDetails/course_player.dart';
import 'package:skiive/features/authentication/screens/courses/courses.dart';
import 'package:skiive/utils/constants/colors.dart';
import 'package:skiive/utils/theme/constantThemes/relatedCard.dart';

import '../../../../models/all_courses_model.dart';
import '../../../../navigation.dart';
import '../../../../utils/http/api.dart';
import '../../../../utils/http/http_client.dart';
import '../../../../utils/loaders/loaders.dart';

class DetailsScreen extends StatefulWidget {
  final String name;
  final String image;
  final String description;
  final String category;
  const DetailsScreen({
    Key? key,
    required this.name,
    required this.image,
    required this.description,
    required this.category,
  }) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String? token;
  String? studentId;
  String? contentId;

  void fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('accessToken');
      studentId = prefs.getString('parameterId');
      contentId = prefs.getString('id');
    });
  }

  Future<void> startCourse() async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      var url =
          Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.bookmark);
      Map body = {
        "courseId": 'a0788d68-5bbf-4827-ad99-9e1d8d40fc5d',
        "studentId": studentId,
      };
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      if (response.statusCode == 201) {
        // final json = jsonDecode(response.body);
        // var token = json['data']['accessToken'];
        // final jsonEmail = jsonDecode(response.body);
        // var userEmail = jsonEmail['data']['email'];

        var uriData = Uri.parse(
            'https://emerge-lms-api.onrender.com/api/v1/course-manager/paid/$studentId');
        var responseData = await http.get(uriData, headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
        final jsonId = jsonDecode(responseData.body);
        var contentId = jsonId['data']['courseManager'][0];
        // final jsonlastName = jsonDecode(responseData.body);
        // var userlastName = jsonlastName['data']['lastName'];

        final SharedPreferences prefs = await _prefs;

        await prefs.setString('id', contentId!);
        // await prefs?.setString('email', userEmail);
        // await prefs?.setString('firstName', userfirstName);
        // await prefs?.setString('lastName', userlastName);

        // email.clear();
        // password.clear();
        SkiiveLoaders.successSnackBar(
            title: 'Course started Successfully!',
            message: 'Welcome to Emerge Learning Management platform.');

        Get.to(() => const CoursesScreen());
      } else if (response.statusCode == 401) {
        SkiiveLoaders.warningSnackBar(
            title: 'Error!',
            message: "This email or password you entered is incorrect.");
      } else if (response.statusCode == 403) {
        SkiiveLoaders.warningSnackBar(
            title: 'Error!',
            message:
                "This email address hasn't been verified. Use the link sent to your email address to complete verification.");
      }
    } catch (e) {
      //Show generic error to user
      SkiiveLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  late String name, image, description, category;
  @override
  void initState() {
    super.initState();
    fetchData();
    name = widget.name;
    image = widget.image;
    description = widget.description;
    category = widget.category;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar.large(
          leading: Container(
            height: 50,
            width: 70,
            margin: const EdgeInsets.only(top: 16, left: 16),
            decoration: BoxDecoration(
              color: SkiiveColors.buttonPrimary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
                onPressed: () => Get.back(),
                color: Colors.white,
                icon: const Icon(LineAwesomeIcons.angle_left)),
          ),
          backgroundColor: Colors.transparent,
          expandedHeight: 200,
          pinned: true,
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(name),
            background: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                image: DecorationImage(
                  image: NetworkImage(image),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.black.withOpacity(0.8)
                  ], stops: const [
                    0.0,
                    0.8
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("$contentId",
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(
                  height: 10,
                ),
                Text(description,
                    style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Text(
                      'Category :',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      category,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => CoursePlayer(
                        name: name,
                        image: image,
                        description: description,
                        category: category));
                  },
                  child: InkWell(
                    onTap: () {
                      startCourse();
                      // Get.to(() => CoursePlayer(
                      //     name: name,
                      //     image: image,
                      //     description: description,
                      //     category: category));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: SkiiveColors.primary,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.blue.withOpacity(0.2),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 2))
                          ]),
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Start Course',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: SkiiveColors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  'Related Courses',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                FutureBuilder<List<CoursesModel>>(
                    future: CoursesApi.getCourses(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      } else if (snapshot.hasData) {
                        List<CoursesModel> courses = snapshot.data!;
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxHeight: 200),
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: courses.length,
                                    itemBuilder: (context, index) =>
                                        GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                name = courses[index].name!;
                                                image = courses[index].image!;
                                                description =
                                                    courses[index].description!;
                                                category =
                                                    courses[index].category!;
                                              });
                                              // Get.to(() => DetailsScreen(
                                              //       name: courses[index].name!,
                                              //       image:
                                              //           courses[index].image!,
                                              //       description: courses[index]
                                              //           .description!,
                                              //       category: courses[index]
                                              //           .category!,
                                              //     ));
                                            },
                                            child: RelatedCard(
                                              image: courses[index].image!,
                                              name: courses[index].name!,
                                            ))),
                              ),
                            )
                          ],
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              ],
            ),
          ),
        )
      ],
    ));
  }
}
