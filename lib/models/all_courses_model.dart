// ignore_for_file: public_member_api_docs, sort_constructors_first
class CoursesModel {
  String? id;
  String? name;
  String? description;
  String? image;
  String? category;
  int? price;

  CoursesModel(
      {this.id,
      this.name,
      this.image,
      this.description,
      this.category,
      this.price});

  CoursesModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    description = json["description"];
    image = json["image"];
    category = json["category"];
    price = json["price"];
  }
}
