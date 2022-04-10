import 'package:flutter/cupertino.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
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
          future: BooksTitleApi.getBooksLocally(context, 'booktitle'),
          builder: (context, snapshot) {
            // final book = snapshot.data[index].testament == 'old';
            final oldTestament =
                snapshot.data?.where((i) => i.testament == 'old').toList();
            final newTestament =
                snapshot.data?.where((i) => i.testament == 'new').toList();

            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  return const Center(child: Text('Some error occurred!'));
                } else {
                  return buildSliverGrid(oldTestament!, newTestament!);
                  // buildList(book!);
                }
            }
          },
        ),
      );

  Widget buildSliverGrid(oldTestament, newTestament) => CustomScrollView(
        slivers: <Widget>[
          SliverStickyHeader.builder(
              builder: (context, state) => Container(
                    height: 40.0,
                    color: (state.isPinned ? globalColor : globalColor).withOpacity(1.0 - state.scrollPercentage),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.center,
                    child: const Text(
                      'Old Testament (39)',
                      style: TextStyle(
                          // color: Colors.white,
                          fontSize: 16),
                    ),
                  ),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200.0,
                  mainAxisSpacing: 7.0,
                  crossAxisSpacing: 10.0,
                  childAspectRatio: 3.6,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    final bookTitle = oldTestament[index];

                    return InkWell(
                      child: Container(
                        margin: const EdgeInsets.all(5.0),
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        // color: bookSelected == bookTitle.key ? globalHighLightColor : null,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: bookSelected == bookTitle.key ? globalHighLightColor : null,
                          borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Text(
                              bookTitle.key,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            Text(
                              bookTitle.val,
                              style: const TextStyle(
                                  fontSize: 13,
                                  // color: Colors.black54,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.italic),
                            )
                          ],
                        ),
                      ),
                      onTap: () => {
                        bookSelected = bookTitle.key,
                        selectedChapter = 1,
                        globalIndex.value = 2,
                        pages[0] = BooksLocalPage( bibleVersions, bookTitle.key, selectedChapter,0),
                        barTitle.value =
                            bookSelected + ' ' + selectedChapter.toString(),
                        colorIndex = 999,
                      },
                    );
                  },
                  childCount: oldTestament.length,
                ),
              )),
          SliverStickyHeader.builder(
              builder: (context, state) => Container(
                    height: 40.0,
                    color: (state.isPinned ? globalColor : globalColor).withOpacity(1.0 - state.scrollPercentage),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.center,
                    child: const Text(
                      'New Testament (27)',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200.0,
                  mainAxisSpacing: 7.0,
                  crossAxisSpacing: 10.0,
                  childAspectRatio: 3.6,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    final bookTitle = newTestament[index];

                    return InkWell(
                      child: Container(
                        margin: const EdgeInsets.all(5.0),
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        // color: bookSelected == bookTitle.key ? globalHighLightColor : null,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: bookSelected == bookTitle.key ? globalHighLightColor : null,
                          borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Text(
                              bookTitle.key,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            Text(
                              bookTitle.val,
                              style: const TextStyle(
                                  fontSize: 13,
                                  // color: Colors.black54,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.italic),
                            )
                          ],
                        ),
                      ),
                      onTap: () => {
                        bookSelected = bookTitle.key,
                        selectedChapter = 1,
                        globalIndex.value = 2,
                        pages[0] = BooksLocalPage(bibleVersions, bookTitle.key, selectedChapter,0),
                        barTitle.value =
                            bookSelected + ' ' + selectedChapter.toString(),
                        colorIndex = 999,
                      },
                    );
                  },
                  childCount: newTestament.length,
                ),
              ))
        ],
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
                padding:
                    const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text(
                      bookTitle.key,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      bookTitle.val,
                      style: const TextStyle(
                          fontSize: 13,
                          // color: Colors.black54,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.italic),
                    )
                  ],
                ),
              ),
              onTap: () => {
                bookSelected = bookTitle.key,
                selectedChapter = 1,
                globalIndex.value = 2,
                pages[0] = BooksLocalPage(bibleVersions, bookTitle.key, selectedChapter,0),
                barTitle.value =
                    bookSelected + ' ' + selectedChapter.toString(),
                colorIndex = 999
              },
            ),
          );
        },
      );
}
