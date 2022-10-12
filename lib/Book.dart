import 'package:book_app/BooksProvider.dart';

class Book {
  late String? image;
  late String? Name;
  late String? AuthorName;
  int? id;

  Book({
    required this.image,
    this.id,
    required this.Name,
    required this.AuthorName,
  });
  Book.fromMap(Map<String, dynamic> map) {
    this.image = map[Cimage];
    if (map[Id] != null) this.id = map[Id];
    this.Name = map[name];
    this.AuthorName = map[authorName];
  }
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map[Cimage] = this.image;
    if (this.id != null) map[Id] = this.id;
    map[name] = this.Name;
    map[authorName] = this.AuthorName;
    return map;
  }
}
