import 'dart:convert';

import 'package:skiive/utils/http/http_client.dart';

import '../../models/all_courses_model.dart';
import 'package:http/http.dart' as http;

class CoursesApi {
  static Future<List<CoursesModel>> getCourses() async {
    var coursesUrl =
        Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.allCourses);
    final response = await http
        .get(coursesUrl, headers: {"Content-Type": "application/json"});
    var coursesData = json.decode(response.body);
    // print("Courses dataaaaaa: ${coursesData['data']['courses']}");
    final List body = coursesData['data']['courses'];
    // print("Bodyyyyyy: $body");
    return body.map((e) => CoursesModel.fromJson(e)).toList();
  }
}
