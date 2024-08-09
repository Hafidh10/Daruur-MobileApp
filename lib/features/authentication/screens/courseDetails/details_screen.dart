// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skiive/features/authentication/screens/courseDetails/course_section.dart';
import 'package:skiive/features/authentication/screens/courses/courses.dart';
import 'package:skiive/utils/constants/colors.dart';
import 'package:skiive/utils/theme/constantThemes/relatedCard.dart';

import '../../../../models/all_courses_model.dart';
import '../../../../navigation.dart';
import '../../../../utils/http/api.dart';
import '../../../../utils/http/http_client.dart';
import '../../../../utils/loaders/loaders.dart';

class DetailsScreen extends StatefulWidget {
  final String id;
  final String name;
  final String image;
  final String description;
  final String category;
  const DetailsScreen({
    Key? key,
    required this.id,
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

  void fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('accessToken');
      studentId = prefs.getString('parameterId');
    });
  }

  String loading = 'init';

  Future<void> startCourse(id) async {
    try {
      setState(() {
        loading = 'processing';
      });
      Future.delayed(const Duration(minutes: 1), () {
        setState(() {
          loading = 'init';
        });
        return false;
      });
      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      var url =
          Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.bookmark);
      Map body = {
        "courseId": id,
        "studentId": studentId,
      };
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      if (response.statusCode == 201) {
        setState(() {
          loading = 'complete';
        });
        SkiiveLoaders.successSnackBar(
            title: 'Course started Successfully!',
            message: 'Welcome to Emerge Learning Management platform.');

        Get.to(() => const CoursesScreen());
      }
    } catch (e) {
      //Show generic error to user
      SkiiveLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  late String id, name, image, description, category;
  @override
  void initState() {
    super.initState();
    fetchData();
    id = widget.id;
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
                Text(name, style: Theme.of(context).textTheme.headlineMedium),
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
                  onTap: () {},
                  child: InkWell(
                    onTap: () {
                      startCourse(id);
                      // Get.to(() => CoursePlayer(
                      //     name: name,
                      //     image: image,
                      //     description: description,
                      //     category: category));
                    },
                    child: SizedBox(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: SkiiveColors.primary),
                          onPressed: () {
                            startCourse(id);
                          },
                          child: loading == 'init'
                              ? const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Text('Start Course'),
                                )
                              : loading == 'processing'
                                  ? const SizedBox(
                                      height: 16,
                                      width: 16,
                                      child: CircularProgressIndicator(
                                        backgroundColor: Colors.white,
                                        valueColor: AlwaysStoppedAnimation(
                                            Color.fromRGBO(172, 173, 189, 0.9)),
                                        strokeWidth: 1.5,
                                      ),
                                    )
                                  : const Icon(Iconsax.tick_circle)),
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
