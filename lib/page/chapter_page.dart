import 'package:flutter/material.dart';
import 'package:simple_bible/api/books_api.dart';
import 'package:simple_bible/model/books.dart';
import 'package:simple_bible/main.dart';
import 'package:simple_bible/page/bible_page.dart';
import 'dart:developer';

class ChapterSelectionPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Scaffold(
    body: FutureBuilder<List<Book>>(
      future: BooksChapterApi.getBooksLocally(context, bibleVersions, bookSelected),
      builder: (context, snapshot) {
        final book = snapshot.data;

        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            if(snapshot.hasError) {
              return Center(child: Text('Some error occurred!'));
            } else {
              return buildList(book!);
            }
        }
      },
    ),
  );

  Widget buildList(chapters) => GridView.builder(
    shrinkWrap: true,
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 6,
    ),
    itemCount: chapters.length,
    itemBuilder: (context, index) {
      final chapterList = chapters[index];
      return GridTile(
        child: InkWell(
          child: Container(
            padding: EdgeInsets.only(top: 30.0,left: 10.0, right: 10.0, ),
            alignment: Alignment.center,
            child: Column(
              children: [
                Text(chapterList.chapter.toString(),
                  style: TextStyle(
                    fontSize: 15,
                    // color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          onTap: () => {
            selectedChapter = chapterList.chapter,
            pages[0] = BooksLocalPage(bibleVersions, bookSelected, chapterList.chapter),
          },
        ),
      );
    },
  );
}