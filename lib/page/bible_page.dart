import 'package:flutter/material.dart';
import 'package:simple_bible/api/books_api.dart';
import 'package:simple_bible/model/books.dart';
import 'package:simple_bible/main.dart';


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

        shouldShowRight = true;
        shouldShowLeft = true;
        if(selectedChapter == lastChapter){
          shouldShowRight = false;
        }else if(selectedChapter == 1){
          shouldShowLeft = false;
        }else{

        }

        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          default:
            if(snapshot.hasError) {
              return const Center(child: Text('Some error occurred!'));
            } else {
              return buildBooks(book!);
            }
        }
      },
    ),
    // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    // floatingActionButton: Stack(
    //   children: <Widget>[
    //     Align(
    //       alignment: Alignment.bottomLeft,
    //       child: shouldShowLeft ? buildNavigationButtonLeft() : null,
    //     ),
    //     Align(
    //       alignment: Alignment.bottomRight,
    //       child: shouldShowRight ? buildNavigationButton() : null,
    //     ),
    //   ],
    // ),
  );


  Widget buildBooks(List<Book> books) => ListView.builder(
    physics: const BouncingScrollPhysics(),
    padding: const EdgeInsets.only(top: 10.0),
    itemCount: books.length,
    itemBuilder: (context, index) {
      final book = books[index];

      return ListTile(
        tileColor: index == colorIndex ? Colors.yellowAccent.shade100 : null,
        title: RichText(
          text: TextSpan(
            // text: book.verse.toString()+' ',
            // style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(text: book.verse.toString()+' ',
                  style: const TextStyle( fontSize: 13, color: Colors.black,fontFamily: 'Roboto',fontWeight: FontWeight.w400, fontStyle: FontStyle.italic)),
              TextSpan(text: book.text , style: const TextStyle( fontSize: 17, color: Colors.black87, fontFamily: 'Roboto', fontWeight: FontWeight.w300)),
            ],
          ),
        ),
        onTap: (){

        },
      );
    },
  );

  // Widget buildNavigationButton() => FloatingActionButton.small(
  //   backgroundColor: Color(0xFFB2D6D3),
  //   child: Icon(Icons.arrow_forward_ios_rounded),
  //   onPressed: () {
  //     if(selectedChapter < lastChapter){
  //       selectedChapter++;
  //     }else{
  //       shouldShowRight = false;
  //     }
  //     BooksLocalPage(jsonName,bookTitle, selectedChapter);
  //   },
  // );

  // Widget buildNavigationButtonLeft() => FloatingActionButton.small(
  //   backgroundColor: Color(0xFFB2D6D3),
  //   child: Icon(Icons.arrow_back_ios_rounded),
  //   onPressed: () {
  //     if(selectedChapter > 1){
  //       selectedChapter--;
  //     }else{
  //       shouldShowLeft = false;
  //     }
  //     BooksLocalPage(jsonName,bookTitle, selectedChapter);
  //   },
  // );

}

