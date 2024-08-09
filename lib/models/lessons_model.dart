class LessonsModule {
  final String id;
  final String title;
  final String description;
  final String number;
  final List<String> resources;
  final String video;
  final String videoLength;
  final String videoTitle;

  LessonsModule({
    required this.id,
    required this.title,
    required this.description,
    required this.number,
    required this.resources,
    required this.video,
    required this.videoLength,
    required this.videoTitle,
  });

  factory LessonsModule.fromJson(Map<String, dynamic> json) {
    return LessonsModule(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      number: json['number'],
      resources: List<String>.from(json['resources']),
      video: json['video'],
      videoLength: json['videoLength'],
      videoTitle: json['videoTitle'],
    );
  }
}
