// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'package:skiive/features/authentication/screens/courseDetails/details_screen.dart';

import '../../../../models/all_courses_model.dart';
import '../../../../models/course_section_model.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/http/api.dart';
import '../../../../utils/theme/constantThemes/relatedCard.dart';

class CoursePlayer extends StatefulWidget {
  const CoursePlayer({
    Key? key,
    required this.subSectionId,
    required this.subSectionTitle,
    required this.sectionNumber,
    required this.sectionTitle,
    required this.sections,
    required this.index,
  }) : super(key: key);

  final int index;
  final int sectionNumber;
  final String sectionTitle;
  final List<SectionModel> sections;
  final String subSectionId;
  final String subSectionTitle;

  @override
  State<CoursePlayer> createState() => _CoursePlayerState();
}

class _CoursePlayerState extends State<CoursePlayer> {
  String? duration;
  String? resources;
  String? title;
  String? token;
  int? track;
  String? videoTitle;

  late YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: "",
    flags: const YoutubePlayerFlags(autoPlay: true),
  );

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('accessToken');
    });
  }

  Future<void> fetchAndPlay(subSectionId) async {
    try {
      var coursesUrl = Uri.parse(
          "https://emerge-lms-api.onrender.com/api/v1/course-sub-section/section/$subSectionId");
      final response = await http.get(coursesUrl, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        String videoUrl = data['data']['video'];
        title = data['data']['title'];
        videoTitle = data['data']['videoTitle'];
        track = data['data']['track'];
        duration = data['data']['videoLength'];
        resources = data['data']['resources'][0];

        // Convert videoLength from seconds to minutes
        int videoLengthInSeconds = int.parse(duration!);
        int minutes = videoLengthInSeconds ~/ 60;
        int seconds = videoLengthInSeconds % 60;
        duration = '$minutes:$seconds';

        String? videoId = YoutubePlayer.convertUrlToId(videoUrl);
        if (videoId != null) {
          _controller = YoutubePlayerController(
            initialVideoId: videoId,
            flags: const YoutubePlayerFlags(autoPlay: true),
          );
        } else {
          print('Invalid video URL');
        }
      } else {
        print('Failed to load video');
      }
    } catch (e) {
      print('Error fetching course data: $e');
      // Display an error message or retry the request
    }
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder(
                  future: fetchAndPlay(widget.subSectionId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: YoutubePlayer(
                              controller: _controller,
                              aspectRatio: 16 / 9,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    title ?? '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      'Track :',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      '$track',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      'Duration :',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      '$duration',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    const Text(
                                      'min',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      'Title :',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: Text(
                                        '$videoTitle',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      'Resources :',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(width: 5),
                                    GestureDetector(
                                      onTap: () {
                                        _launchURL(resources!);
                                      },
                                      child: Text(
                                        'Download PDF',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
                const SizedBox(height: 70),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: const Text(
                    'Related Courses',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
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
                              constraints: const BoxConstraints(maxHeight: 200),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: courses.length,
                                itemBuilder: (context, index) =>
                                    GestureDetector(
                                  onTap: () {
                                    Get.to(() => DetailsScreen(
                                          image: courses[index].image!,
                                          name: courses[index].name!,
                                          description:
                                              courses[index].description!,
                                          category: courses[index].category!,
                                          id: courses[index].id!,
                                        ));
                                  },
                                  child: RelatedCard(
                                    image: courses[index].image!,
                                    name: courses[index].name!,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ],
            ),
            const Positioned(
              top: 0,
              left: 0,
              child: BackButton(color: Colors.blueAccent),
            ),
          ],
        ),
      ),
    );
  }
}
