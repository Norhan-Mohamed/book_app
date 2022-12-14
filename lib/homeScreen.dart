import 'package:book_app/BooksProvider.dart';
import 'package:flutter/material.dart';

import 'Book.dart';
import 'BooksProvider.dart';

class Home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<Home> {
  // @override
  List<Book> bookList = [];
  TextEditingController myController = TextEditingController();
  TextEditingController mySecondController = TextEditingController();
  TextEditingController myThirdController = TextEditingController();
  late String Name;
  late String newImage;
  late String AuthorName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0977cb),
        centerTitle: true,
        title: Text(
          'Available Books',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: FutureBuilder<List<Book>>(
            future: BookProvider.instance.getBook(),
            builder: (context, snapshot) {
              if (snapshot.hasError)
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              } else {
                bookList = snapshot.data!;
                return ListView.builder(
                    itemCount: bookList.length,
                    itemBuilder: (context, index) {
                      Book book = bookList[index];
                      return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(children: [
                                Container(
                                  height: 100,
                                  width: 100,
                                  // fit: BoxFit.fill,
                                  alignment: Alignment.center,
                                  child: Image(
                                    image: NetworkImage(
                                      book.image.toString(),
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Expanded(
                                  child: Column(children: [
                                    Text(book.Name.toString()),
                                    Text(book.AuthorName.toString()),
                                  ]),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.blue,
                                  ),
                                  color: Colors.white,
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                              'Delete Book',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 35),
                                            ),
                                            content: Text(
                                              'Are you sure you want to delete this book?',
                                              style: TextStyle(
                                                  color: Colors.black45,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            actions: [
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 25),
                                                  )),
                                              ElevatedButton(
                                                  onPressed: () async {
                                                    if (book.id != null)
                                                      await BookProvider
                                                          .instance
                                                          .delete(book.id);
                                                    Navigator.of(context).pop();
                                                    setState(() {});
                                                  },
                                                  child: Text(
                                                    'Yes',
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 25),
                                                  )),
                                            ],
                                          );
                                        });
                                  },
                                ),
                              ]),
                            ]),
                      );
                    });
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            await showModalBottomSheet(
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25.0))),
              context: context,
              barrierColor: Colors.white70,
              backgroundColor: Colors.white,
              builder: (context) => Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                        ),
                        TextFormField(
                          controller: myController,
                          decoration: InputDecoration(hintText: 'Book Title'),
                          autofocus: true,
                        ),
                        TextFormField(
                          controller: mySecondController,
                          decoration: InputDecoration(hintText: 'Book Author'),
                        ),
                        TextFormField(
                          controller: myThirdController,
                          decoration:
                              InputDecoration(hintText: 'Book Cover URL'),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: 200,
                          height: 35,
                          child: ElevatedButton(
                            onPressed: () async {
                              await BookProvider.instance.insert(Book(
                                  image: myController.text,
                                  Name: mySecondController.text,
                                  AuthorName: myThirdController.text));
                              print(bookList);

                              Navigator.pop(context);
                              // setState(() {});
                            },
                            child: Text(
                              'ADD',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xff0977cb),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            );
            setState(() {});
          }),
    );
  }
}
