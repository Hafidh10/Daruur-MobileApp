class SectionModel {
  final String id;
  final int number;
  final String title;
  final List<Subsection> subsections;

  SectionModel(
      {required this.id,
      required this.number,
      required this.title,
      required this.subsections});

  factory SectionModel.fromJson(Map<String, dynamic> json) {
    var list = json['subsections'] as List;
    List<Subsection> subsectionList =
        list.map((i) => Subsection.fromJson(i)).toList();

    return SectionModel(
      id: json['id'],
      number: json['number'],
      title: json['title'],
      subsections: subsectionList,
    );
  }
}

class Subsection {
  final String id;
  final String title;

  Subsection({required this.id, required this.title});

  factory Subsection.fromJson(Map<String, dynamic> json) {
    return Subsection(
      id: json['id'],
      title: json['title'],
    );
  }
}
