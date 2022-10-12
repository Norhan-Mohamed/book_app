import 'package:book_app/Book.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

String name = 'Name';
final String Id = 'id';
final String authorName = 'AuthorName';
final dynamic Cimage = 'image';

class BookProvider {
  late Database db;
  static final BookProvider instance = BookProvider._internal();

  factory BookProvider() {
    return instance;
  }
  BookProvider._internal();

  Future open() async {
    db = await openDatabase(join(await getDatabasesPath(), 'books.db'),
        version: 1, onCreate: (Database db, int version) async {
      await db.execute('''
create table BookTable ( 
  $Id integer primary key autoincrement,
  $name text not null,
 $authorName text not null,
  $Cimage text not null
  )
''');
    });
  }

  Future<Book> insert(Book book) async {
    book.id = await db.insert('BookTable', book.toMap());
    return book;
  }

  Future<List<Book>> getBook() async {
    List<Map<String, dynamic>> maps = await db.query('BookTable');
    if (maps.isEmpty)
      return [];
    else {
      List<Book> books = [];
      maps.forEach((element) {
        books.add(Book.fromMap(element as Map<String, dynamic>));
      });
      return books;
    }
  }

  Future<int> delete(int? id) async {
    return await db.delete('BookTable', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(Book book) async {
    return await db.update('BookTable', book.toMap(),
        where: '$Id = ?', whereArgs: [book.id]);
  }

  Future close() async => db.close();
}
