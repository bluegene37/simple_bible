import 'package:flutter/material.dart';
import 'package:simple_bible/api/books_api.dart';
import 'package:simple_bible/model/books.dart';
import 'package:simple_bible/main.dart';
import 'package:simple_bible/page/bible_page.dart';

class ChapterSelectionPage extends StatelessWidget {
  const ChapterSelectionPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) => Scaffold(
    body: FutureBuilder<List<Book>>(
      future: BooksChapterApi.getBooksLocally(context, bibleVersions, bookSelected),
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

  Widget buildList(chapters) => GridView.builder(
    shrinkWrap: true,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 6,
    ),
    itemCount: chapters.length,
    itemBuilder: (context, index) {
      final chapterList = chapters[index];
      return GridTile(
        child: InkWell(
          child: Container(
            padding: const EdgeInsets.only(top: 30.0,left: 10.0, right: 10.0, ),
            alignment: Alignment.center,
            child: Column(
              children: [
                Text(chapterList.chapter.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    // color: Colors.black54,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          onTap: () => {
            selectedChapter = chapterList.chapter,
            globalIndex.value = 2,
            pages[0] = BooksLocalPage(bibleVersions, bookSelected, chapterList.chapter),
            barTitle.value = bookSelected +' '+selectedChapter.toString(),
            colorIndex = 999
          },
        ),
      );
    },
  );
}