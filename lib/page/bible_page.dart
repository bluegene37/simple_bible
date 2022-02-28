import 'package:flutter/material.dart';
import 'package:simple_bible/api/books_api.dart';
import 'package:simple_bible/model/books.dart';
import 'dart:developer';

class BooksLocalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    body: FutureBuilder<List<Book>>(
      future: BooksApi.getBooksLocally(context),
      builder: (context, snapshot) {
        final book = snapshot.data; // <-- Your data
        log(book.toString());
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
        title: Text(book.text),
        // subtitle: Text(book.text),
      );
    },
  );
}