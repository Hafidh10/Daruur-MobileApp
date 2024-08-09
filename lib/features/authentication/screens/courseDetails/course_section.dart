// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'package:skiive/features/authentication/screens/courseDetails/course_player.dart';
import 'package:skiive/features/authentication/screens/courseDetails/details_screen.dart';
import 'package:skiive/models/course_section_model.dart';
import 'package:skiive/utils/theme/constantThemes/courses_section_card.dart';

import '../../../../models/all_courses_model.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/http/api.dart';
import '../../../../utils/theme/constantThemes/relatedCard.dart';

class CourseSection extends StatefulWidget {
  final String contentId;
  final String name;

  const CourseSection({
    Key? key,
    required this.contentId,
    required this.name,
  }) : super(key: key);

  @override
  State<CourseSection> createState() => _CourseSectionState();
}

class _CourseSectionState extends State<CourseSection> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String? token;

  void fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('accessToken');
    });
  }

  Future<List<SectionModel>> getMyCourses(contentId) async {
    var coursesUrl = Uri.parse(
        "https://emerge-lms-api.onrender.com/api/v1/course-section/student/$contentId");
    final response = await http.get(coursesUrl, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      var courseSection = json.decode(response.body);
      final List body = courseSection['data']['sections'];
      return body.map((e) => SectionModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load courses');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
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
          'Course Sections',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: SkiiveColors.accent,
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.name,
                      style: Theme.of(context).textTheme.headlineMedium),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              FutureBuilder<List<SectionModel>>(
                future: getMyCourses(widget.contentId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    List<SectionModel> sections = snapshot.data!;
                    return CourseSectionList(sections: sections);
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

class CourseSectionList extends StatelessWidget {
  final List<SectionModel> sections;

  const CourseSectionList({Key? key, required this.sections}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        children: [
          ConstrainedBox(
            constraints:
                BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: sections.length,
                itemBuilder: (context, index) {
                  return CourseSectionListItem(
                    section: sections[index],
                    sections: sections,
                    index: index,
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CourseSectionListItem extends StatelessWidget {
  final SectionModel section;
  final List<SectionModel> sections;
  final int index;

  const CourseSectionListItem({
    Key? key,
    required this.section,
    required this.sections,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(vertical: 12),
      leading: Text(section.number.toString()),
      title: Text(section.title),
      children: <Widget>[
        Column(
          children: section.subsections.map<Widget>((subsection) {
            return GestureDetector(
              onTap: () {
                Get.to(CoursePlayer(
                  subSectionId: subsection.id,
                  subSectionTitle: subsection.title,
                  sectionNumber: section.number,
                  sectionTitle: section.title,
                  sections: sections,
                  index: index,
                ));
              },
              child: ListTile(
                title: Text(subsection.title),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
