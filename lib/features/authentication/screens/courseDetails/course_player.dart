import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:skiive/features/authentication/screens/courseDetails/details_screen.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../models/all_courses_model.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/http/api.dart';
import '../../../../utils/theme/constantThemes/relatedCard.dart';

class CoursePlayer extends StatefulWidget {
  final String name;
  final String image;
  final String description;
  final String category;
  const CoursePlayer({
    Key? key,
    required this.name,
    required this.image,
    required this.description,
    required this.category,
  }) : super(key: key);

  @override
  State<CoursePlayer> createState() => _CoursePlayerState();
}

class _CoursePlayerState extends State<CoursePlayer> {
  final videoURL = 'https://www.youtube.com/watch?v=pwNHFv6uhz4';

  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    final videoID = YoutubePlayer.convertUrlToId(videoURL);
    _controller = YoutubePlayerController(
        initialVideoId: videoID!,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [
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
              background: Column(
            children: [
              YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                bottomActions: [
                  CurrentPosition(),
                  ProgressBar(
                    isExpanded: true,
                    colors: const ProgressBarColors(
                        playedColor: SkiiveColors.primary,
                        handleColor: SkiiveColors.primary),
                  ),
                  const PlaybackSpeedButton(),
                ],
              ),
            ],
          )),
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              // Container(
              //   height: 250,
              //   width: double.infinity,
              //   decoration: BoxDecoration(
              //     color: Colors.grey,
              //     image: DecorationImage(
              //       image: NetworkImage(widget.image),
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              // ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.name,
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(widget.description,
                        style: Theme.of(context).textTheme.labelMedium),
                    const SizedBox(
                      height: 30,
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
                                                  Get.to(() => DetailsScreen(
                                                        name: courses[index]
                                                            .name!,
                                                        image: courses[index]
                                                            .image!,
                                                        description:
                                                            courses[index]
                                                                .description!,
                                                        category: courses[index]
                                                            .category!,
                                                      ));
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
            ],
          ),
        ),
      ]),
    );
  }
}
