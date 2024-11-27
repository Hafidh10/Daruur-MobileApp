class MyCoursesModel {
  final String id;
  final dynamic assignment;
  final bool paused;
  final dynamic quiz;
  final Course course;

  MyCoursesModel({
    required this.id,
    this.assignment,
    required this.paused,
    this.quiz,
    required this.course,
  });

  factory MyCoursesModel.fromJson(Map<String, dynamic> json) {
    return MyCoursesModel(
      id: json['id'],
      assignment: json['assignment'],
      paused: json['paused'],
      quiz: json['quiz'],
      course: Course.fromJson(json['course']),
    );
  }
}

class Course {
  final String id;
  final String category;
  final String description;
  final String image;
  final String name;
  final String content;
  final int price;

  Course(
      {required this.id,
      required this.category,
      required this.description,
      required this.image,
      required this.name,
      required this.content,
      required this.price});

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      category: json['category'],
      description: json['description'],
      image: json['image'],
      name: json['name'],
      content: json['content']['id'],
      price: json['price'],
    );
  }
}

class Tutor {
  final String id;

  Tutor({required this.id});

  factory Tutor.fromJson(Map<String, dynamic> json) {
    return Tutor(
      id: json['id'],
    );
  }
}
