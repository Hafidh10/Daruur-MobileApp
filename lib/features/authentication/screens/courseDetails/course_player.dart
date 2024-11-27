// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:video_player/video_player.dart';
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
    required this.sectionID,
    required this.sectionNumber,
    required this.sectionTitle,
    required this.sections,
    required this.index,
    required this.courseId,
  }) : super(key: key);

  final String courseId;
  final int index;
  final int sectionNumber;
  final String sectionID;
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
  String? parameterId;
  int? track;
  String? videoTitle;

  late YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: "",
    flags: const YoutubePlayerFlags(
      autoPlay: true,
    ),
  );
  Timer? _progressTimer;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  late String courseId;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the YoutubePlayerController
    _progressTimer?.cancel(); // Cancel the timer if it's running
    super.dispose();
  }

  void fetchData() async {
    print('Fetching data.......');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('accessToken');
      parameterId = prefs.getString('parameterId');
    });
    fetchAndPlay(widget.subSectionId);
  }

  Future<void> fetchAndPlay(subSectionId) async {
    try {
      var coursesUrl = Uri.parse(
          "https://api.emergekenya.org/api/v1/course-sub-section/section/$subSectionId");
      final response = await http.get(coursesUrl, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      print("Responseeeeeeeeeeeeee: ${json.decode(response.body)}");
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        String videoUrl = data['data']['video'];
        title = data['data']['title'];
        videoTitle = data['data']['videoTitle'];
        track = data['data']['track'];
        duration = data['data']['videoLength'];
        resources = data['data']['resources'][0];

        // Extract the video ID from the YouTube URL
        String videoId = YoutubePlayer.convertUrlToId(videoUrl) ?? '';

        // Initialize the YoutubePlayerController
        _controller = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: true,
          ),
        );

        // Add a listener to track video state
        _controller.addListener(() {
          if (_controller.value.isPlaying) {
            print("Video is playing");
            _trackVideoProgress(); // Start tracking if playing
          } else {
            print("Video is not playing");
            _progressTimer?.cancel(); // Stop tracking if not playing
          }
        });

        // Convert videoLength from seconds to minutes
        int videoLengthInSeconds = int.parse(duration!);
        int minutes = videoLengthInSeconds ~/ 60;
        int seconds = videoLengthInSeconds % 60;
        duration = '$minutes:$seconds';

        // Start tracking video progress
        // _trackVideoProgress();
      } else {
        print(
            'Failed to load videoooooo: ${response.statusCode} - ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Failed to load videooooo: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('Error fetching course data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching course data: $e')),
      );
    }
  }

  Future<void> _trackVideoProgress() async {
    print("Tracking videoooooooo");
    if (_controller.value.isPlaying) {
      int videoViewedTime = _controller.value.position.inSeconds;
      print('Current video position: $videoViewedTime seconds');
      sendVideoProgressToApi(videoViewedTime);
    } else {
      print(
          "Sending tracking data failed"); // Stop the timer if video is not playing
    }
    // Cancel any existing timer to avoid multiple timers running
    _progressTimer?.cancel();

    // Start a new timer to send progress every second
    _progressTimer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      print("Progress Timerrrrrrrrrrr");
      if (_controller.value.isPlaying) {
        int videoViewedTime = _controller.value.position.inSeconds;
        print('Current video position: $videoViewedTime seconds');
        sendVideoProgressToApi(videoViewedTime);
      } else {
        t.cancel(); // Stop the timer if video is not playing
      }
    });
  }

  Future<void> sendVideoProgressToApi(int videoViewedTime) async {
    print('Sending video progress: $videoViewedTime seconds');
    var url = Uri.parse(
        'https://api.emergekenya.org/api/v1/course-manager/track/progress/student');
    // Create the body as per the API specification
    Map<String, dynamic> body = {
      "completedPdf": true,
      "courseId": widget.courseId, // Use the actual course ID
      "courseSectionId": widget.sectionID, // Use the actual section ID
      "courseSubSectionId": widget.subSectionId, // Use the actual subsection ID
      "studentId": parameterId, // Use the actual student ID
      "videoViewedTime": videoViewedTime, // Current video position in seconds
    };

    final response = await http.post(
      url,
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 201) {
      print(
          'Progress updated successfully..............................: ${response.body}');
    } else {
      print(
          'Failed to update progress...................................: ${response.statusCode} - ${response.body}');
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
    return SafeArea(
      child: Scaffold(
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
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                child: _controller != null
                                    ? YoutubePlayer(
                                        controller: _controller,
                                        showVideoProgressIndicator: true,
                                        aspectRatio: 16 / 9,
                                        progressIndicatorColor: Colors
                                            .amber, // Customize progress indicator color
                                        progressColors: ProgressBarColors(
                                          playedColor: Colors.blueAccent,
                                          handleColor: Colors.blueAccent,
                                        ),
                                        onReady: () {
                                          // _trackVideoProgress();
                                        },
                                      )
                                    : Center(
                                        child: CircularProgressIndicator())),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
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
                                        width:
                                            MediaQuery.of(context).size.width *
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
                                            decoration:
                                                TextDecoration.underline,
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
                                constraints:
                                    const BoxConstraints(maxHeight: 200),
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
                                      price: courses[index].price!,
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
                top: 15,
                left: 0,
                child: BackButton(color: Colors.blueAccent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
