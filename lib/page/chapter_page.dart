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
      future: bookSelectedHist != bookSelected || selectedChapterHist != selectedChapter || chaptersScreen.isEmpty || refreshChapter ? BooksChapterApi.getBooksLocally(context, bibleVersions, bookSelected) : null,
      builder: (context, snapshot) {

        final book = bookSelectedHist != bookSelected || selectedChapterHist != selectedChapter || chaptersScreen.isEmpty ?  snapshot.data : chaptersScreen;
        if(bookSelectedHist != bookSelected){selectedChapterHist = 0;}

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
      if(selectedChapter > chapters.length){
        selectedChapter = 1;
      }
      return GridTile(
        child: InkWell(
          child: Container(
            margin: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(shape: BoxShape.circle,color: selectedChapter == chapterList.chapter ? themeColorShades[colorSliderIdx.value] : null),
            // color: selectedChapter == chapterList.chapter ? globalHighLightColor : null,
            // padding: const EdgeInsets.only(top: 20.0,left: 10.0, right: 10.0, ),
            // alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(chapterList.chapter.toString(),
                  // textAlign: TextAlign.center,
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
            box.put('selectedChapter', chapterList.chapter),
            globalIndex.value = 2,
            pages[0] = BooksLocalPage(bibleVersions, bookSelected, chapterList.chapter, 0),
            barTitle.value = '$bookSelected $selectedChapter',
            colorIndex = 999
          },
        ),
      );
    },
  );
}