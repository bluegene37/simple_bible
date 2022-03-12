import 'package:flutter/material.dart';
import 'package:simple_bible/api/books_api.dart';
import 'package:simple_bible/model/books.dart';
import 'package:simple_bible/main.dart';
import 'dart:developer';


class BooksLocalPage extends StatelessWidget {
  final String jsonName;
  final String bookTitle;
  final int bookChapter;

  const BooksLocalPage(this.jsonName,this.bookTitle, this.bookChapter);

  @override
  Widget build(BuildContext context) => Scaffold(
    body: FutureBuilder<List<Book>>(
      future: BooksApi.getBooksLocally(context, jsonName, bookTitle, bookChapter),
      builder: (context, snapshot) {
        final book = snapshot.data;

        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            if(snapshot.hasError) {
              return Center(child: Text('Some error occurred!'));
            } else {
              return buildBooks(book!);
            }
        }
      },
    ),
  );


  Widget buildBooks(List<Book> books) => ListView.builder(

    physics: BouncingScrollPhysics(),
    itemCount: books.length,
    itemBuilder: (context, index) {

      final book = books[index];

      return ListTile(
        title: Text(
          book.verse.toString() +' '+ book.text,
          style: TextStyle(fontSize: 16),
        ),
        // trailing: new Icon(icon),
        // subtitle: Text(book.text),
      );
    },
  );
}