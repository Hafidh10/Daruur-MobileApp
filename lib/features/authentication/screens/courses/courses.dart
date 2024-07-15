// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skiive/utils/constants/section_heading.dart';
import 'package:skiive/utils/theme/constantThemes/card.dart';

import '../../../../models/all_courses_model.dart';
import '../../../../utils/http/api.dart';
import '../courseDetails/details_screen.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: SkiiveHeadingSection(
                title: 'Courses',
                onPressed: () {},
              ),
            ),
            FutureBuilder<List<CoursesModel>>(
                future: CoursesApi.getCourses(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  } else if (snapshot.hasData) {
                    List<CoursesModel> courses = snapshot.data!;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Column(
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                                maxHeight: MediaQuery.of(context).size.height),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
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
                                            Get.to(() => DetailsScreen(
                                                  image: courses[index].image!,
                                                  name: courses[index].name!,
                                                  description: courses[index]
                                                      .description!,
                                                  category:
                                                      courses[index].category!,
                                                ));
                                          },
                                          child: SkiiveCard(
                                            // ignore: unnecessary_string_interpolations
                                            image: courses[index].image!,
                                            name: courses[index].name!,
                                          ))),
                            ),
                          )
                        ],
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  // final courses = snapshot.data;
                  // print("Courses data: $courses");
                }),
          ],
        ),
      ),
    );
  }
}
