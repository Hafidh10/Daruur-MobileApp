// ignore_for_file: prefer_const_declarations, library_private_types_in_public_api

class ApiEndPoints {
  static final String baseUrl = 'https://api.emergekenya.org/api/v1/';
  static _AuthEndPoints authEndPoints = _AuthEndPoints();
}

class _AuthEndPoints {
  final String register = 'auth/signup';
  final String login = 'auth/signin';
  final String googleLogin = 'auth/google/signin';
  final String forgotPassword = 'auth/password-reset-request';
  final String studentProfile = 'students/profile';
  final String allCourses = 'course';
  final String bookmark = 'course-manager/bookmark';
  final String pay = 'course-manager/pay';
  final String certificate = 'certificate';
  // final String paid = 'course-manager/paid/';
}
