// ignore_for_file: prefer_const_declarations, library_private_types_in_public_api

class ApiEndPoints {
  static final String baseUrl = 'https://emerge-lms-api.onrender.com/api/v1/';
  static _AuthEndPoints authEndPoints = _AuthEndPoints();
}

class _AuthEndPoints {
  final String register = 'auth/signup';
  final String login = 'auth/signin';
  final String studentProfile = 'students/profile';
  final String bookmark = 'course-manager/bookmark';
  // final String paid = 'course-manager/paid/';
}
