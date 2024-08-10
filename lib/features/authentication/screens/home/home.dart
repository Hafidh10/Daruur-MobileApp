// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_unnecessary_containers, unused_field
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skiive/models/all_courses_model.dart';
import 'package:skiive/utils/constants/colors.dart';
import 'package:skiive/utils/constants/section_heading.dart';
import 'package:skiive/utils/http/api.dart';
import 'package:skiive/utils/theme/constantThemes/card.dart';
import 'package:skiive/utils/theme/constantThemes/headerContainer.dart';
import 'package:skiive/utils/theme/constantThemes/homeAppBar.dart';
import '../courseDetails/details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String? studentProfile;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      studentProfile = prefs.getString('firstName');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SkiiveHeaderContainer(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkiiveHomeAppbar(),
                  Padding(
                    padding: const EdgeInsets.only(left: 33, top: 20),
                    child: SizedBox(
                      width: 150,
                      child: Text(
                        'what would you like to learn today?',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .apply(color: SkiiveColors.white),
                      ),
                    ),
                  ),
                  // SizedBox(height: 20),
                  // SearchContainer(
                  //   text: 'Search here',
                  // ),
                ],
              )),
              SizedBox(
                height: 20,
              ),
              //Body
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: SkiiveColors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 2))
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "GENERAL LEARNING PROGRESS",
                          style: TextStyle(color: SkiiveColors.darkerGrey),
                        ),
                        Text("0%",
                            style: TextStyle(
                                color: SkiiveColors.primary,
                                fontSize: 38,
                                fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: SkiiveColors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 2))
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "CERTIFICATIONS",
                          style: TextStyle(color: SkiiveColors.darkerGrey),
                        ),
                        Text("0",
                            style: TextStyle(
                                color: SkiiveColors.primary,
                                fontSize: 38,
                                fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: SkiiveColors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 2))
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "COURSES SUBSCRIBED",
                          style: TextStyle(color: SkiiveColors.darkerGrey),
                        ),
                        Text("0",
                            style: TextStyle(
                                color: SkiiveColors.primary,
                                fontSize: 38,
                                fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),

              SkiiveHeadingSection(
                title: 'Courses',
                onPressed: () {},
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
                            Padding(
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
                                                  id: courses[index].id!,
                                                ));
                                          },
                                          child: SkiiveCard(
                                            // ignore: unnecessary_string_interpolations
                                            image: courses[index].image!,
                                            name: courses[index].name!,
                                          ))),
                            )
                          ],
                        ),
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
      ),
    );
  }
}
