import 'package:simple_bible/main.dart';
import 'package:flutter/material.dart';
import 'package:simple_bible/page/bible_page.dart';
import 'package:simple_bible/api/books_api.dart';
import 'package:simple_bible/model/books.dart';

class BooksSelectionPage extends StatelessWidget {
  const BooksSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    body: FutureBuilder<List<BookTitle>>(
      future: BooksTitleApi.getBooksLocally(context),
      builder: (context, snapshot) {
        final book = snapshot.data;

        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          default:
            if(snapshot.hasError) {
              return const Center(child: Text('Some error occurred!'));
            } else {
              return buildList(book!);
            }
        }
      },
    ),
  );

  Widget buildList(bibleBooks) => GridView.builder(
    shrinkWrap: true,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
              padding: const EdgeInsets.only(top: 20.0,left: 10.0, right: 10.0),
              alignment: Alignment.center,
                child: Column(
                  children: [
                    Text(bookTitle.key,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w300,
                        ),
                    ),
                    Text(bookTitle.val,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.italic
                      ),
                    )
                  ],
                ),
          ),
          onTap: () => {
            bookSelected = bookTitle.key,
            selectedChapter = 1,
            globalIndex.value = 2,
            pages[0] = BooksLocalPage(bibleVersions, bookTitle.key, selectedChapter),
            barTitle.value = bookSelected +' '+selectedChapter.toString(),
            colorIndex = 999
          },
        ),
      );
    },
  );
}