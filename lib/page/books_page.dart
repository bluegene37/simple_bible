import 'package:simple_bible/main.dart';
import 'package:flutter/material.dart';
import 'package:simple_bible/page/bible_page.dart';
import 'package:simple_bible/api/books_api.dart';
import 'package:simple_bible/model/books.dart';

class BooksSelectionPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Scaffold(
    body: FutureBuilder<List<BookTitle>>(
      future: BooksTitleApi.getBooksLocally(context, 'booktitle'),
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

  Widget buildList(bibleBooks) => GridView.builder(
    shrinkWrap: true,
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      // crossAxisSpacing: 8,
      // mainAxisSpacing: 4,
      childAspectRatio: (100 / 30),
    ),
    itemCount: bibleBooks.length,
    itemBuilder: (context, index) {
      final bookTitle = bibleBooks[index];

      return GridTile(
        child: InkWell(
          child: Container(
              padding: EdgeInsets.only(top: 20.0,left: 10.0, right: 10.0),
              alignment: Alignment.center,
                child: Column(
                  children: [
                    Text(bookTitle.key,
                        style: TextStyle(
                          fontSize: 15,
                          // color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                    ),
                    Text(bookTitle.val,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                        // fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
          ),
          onTap: () => {
            barTitle = bookTitle.key,
            bookSelected = bookTitle.key,
            selectedChapter = 1,
            pages[0] = BooksLocalPage(bibleVersions, bookTitle.key, selectedChapter),
          },
        ),
      );
    },
  );
}