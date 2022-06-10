import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:simple_bible/main.dart';
import 'package:flutter/material.dart';
import 'package:simple_bible/api/books_api.dart';
import 'package:simple_bible/model/books.dart';
import 'chapter_page.dart';

final ItemScrollController itemScrollController = ItemScrollController();
final ItemScrollController itemScrollController2 = ItemScrollController();

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
                  return buildListViewRow(oldTestament!,newTestament!);
                    // buildSliverGrid(oldTestament!, newTestament!);
                }
            }
          },
        ),
      );

  Widget buildSliverGrid(oldTestament, newTestament) => Row(
    children: [
      Expanded(
          child: CustomScrollView(
              slivers: <Widget>[
                SliverStickyHeader.builder(
                    builder: (context, state) => Container(
                      height: 40.0,
                      color: (state.isPinned ? themeColorShades[colorSliderIdx.value] : themeColorShades[colorSliderIdx.value]).withOpacity(1.0 - state.scrollPercentage),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      alignment: Alignment.center,
                      child: const Text( 'Old Testament (39)', style: TextStyle(fontSize: 16),
                      ),
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          final bookTitle = oldTestament[index];

                          return InkWell(
                            child: Container(
                              margin: const EdgeInsets.all(4.0),
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: bookSelected == bookTitle.key ? themeColorShades[colorSliderIdx.value] : null,
                                borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                              ),
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Text(bookTitle.key, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w300,),),
                                  Text(bookTitle.val, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic),)
                                ],
                              ),
                            ),
                            onTap: () => {
                              bookSelected = bookTitle.key,
                              box.put('bookSelected', bookTitle.key),
                              selectedChapter = 1,
                              globalIndex.value = 1,
                              pages[0] = const ChapterSelectionPage(),
                              barTitle.value = "Chapters",
                              colorIndex = 999,
                            },
                          );
                        },
                        childCount: oldTestament.length,
                      ),
                    )
                ),
              ]
          ),
      ),
      Expanded(
          child: CustomScrollView(
              slivers: <Widget>[
                SliverStickyHeader.builder(
                    builder: (context, state) => Container(
                      height: 40.0,
                      color: (state.isPinned ? themeColorShades[colorSliderIdx.value] : themeColorShades[colorSliderIdx.value]).withOpacity(1.0 - state.scrollPercentage),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      alignment: Alignment.center,
                      child: const Text('New Testament (27)', style: TextStyle(fontSize: 16),),
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          final bookTitle = newTestament[index];
                          return InkWell(
                            child: Container(
                              margin: const EdgeInsets.all(5.0),
                              padding: const EdgeInsets.symmetric(vertical: 5.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: bookSelected == bookTitle.key ? themeColorShades[colorSliderIdx.value] : null,
                                borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                              ),
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Text(bookTitle.key, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w300,),),
                                  Text(bookTitle.val, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic),)
                                ],
                              ),
                            ),
                            onTap: () => {
                              bookSelected = bookTitle.key,
                              box.put('bookSelected', bookTitle.key),
                              selectedChapter = 1,
                              globalIndex.value = 1,
                              pages[0] = const ChapterSelectionPage(),
                              barTitle.value = "Chapters",
                              colorIndex = 999,
                            },
                          );
                        },
                        childCount: newTestament.length,
                      ),
                    )
                )
              ]
          )
      )
    ],
  );
      // CustomScrollView(
      //
      //   slivers: <Widget>[
      //     SliverStickyHeader.builder(
      //         builder: (context, state) => Container(
      //               height: 40.0,
      //               color: (state.isPinned ? themeColorShades[colorSliderIdx.value] : themeColorShades[colorSliderIdx.value]).withOpacity(1.0 - state.scrollPercentage),
      //               padding: const EdgeInsets.symmetric(horizontal: 16.0),
      //               alignment: Alignment.center,
      //               child: const Text(
      //                 'Old Testament (39)',
      //                 style: TextStyle(
      //                     // color: Colors.white,
      //                     fontSize: 16),
      //               ),
      //             ),
      //         sliver: SliverList(
      //           // gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
      //           //   maxCrossAxisExtent: 200.0,
      //           //   mainAxisSpacing: 7.0,
      //           //   crossAxisSpacing: 10.0,
      //           //   childAspectRatio: 3.6,
      //           // ),
      //           delegate: SliverChildBuilderDelegate(
      //             (BuildContext context, int index) {
      //               final bookTitle = oldTestament[index];
      //
      //               return InkWell(
      //                 child: Container(
      //                   margin: const EdgeInsets.all(4.0),
      //                   padding: const EdgeInsets.symmetric(vertical: 4.0),
      //                   decoration: BoxDecoration(
      //                     shape: BoxShape.rectangle,
      //                     color: bookSelected == bookTitle.key ? themeColorShades[colorSliderIdx.value] : null,
      //                     borderRadius: const BorderRadius.all(Radius.circular(30.0)),
      //                   ),
      //                   alignment: Alignment.center,
      //                   child: Column(
      //                     children: [
      //                       Text(
      //                         bookTitle.key,
      //                         style: const TextStyle(
      //                           fontSize: 17,
      //                           fontWeight: FontWeight.w300,
      //                         ),
      //                       ),
      //                       Text(
      //                         bookTitle.val,
      //                         style: const TextStyle(
      //                             fontSize: 13,
      //                             // color: Colors.black54,
      //                             fontWeight: FontWeight.w400,
      //                             fontStyle: FontStyle.italic),
      //                       )
      //                     ],
      //                   ),
      //                 ),
      //                 onTap: () => {
      //                   bookSelected = bookTitle.key,
      //                   box.put('bookSelected', bookTitle.key),
      //                   selectedChapter = 1,
      //                   globalIndex.value = 1,
      //                   pages[0] = const ChapterSelectionPage(),
      //                   barTitle.value = "Chapters",
      //                   colorIndex = 999,
      //                 },
      //               );
      //             },
      //             childCount: oldTestament.length,
      //           ),
      //         )),
      //     SliverStickyHeader.builder(
      //         builder: (context, state) => Container(
      //               height: 40.0,
      //               color: (state.isPinned ? themeColorShades[colorSliderIdx.value] : themeColorShades[colorSliderIdx.value]).withOpacity(1.0 - state.scrollPercentage),
      //               padding: const EdgeInsets.symmetric(horizontal: 16.0),
      //               alignment: Alignment.center,
      //               child: const Text(
      //                 'New Testament (27)',
      //                 style: TextStyle(fontSize: 16),
      //               ),
      //             ),
      //         sliver: SliverList(
      //           // gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
      //           //   maxCrossAxisExtent: 200.0,
      //           //   mainAxisSpacing: 7.0,
      //           //   crossAxisSpacing: 10.0,
      //           //   childAspectRatio: 3.6,
      //           // ),
      //           delegate: SliverChildBuilderDelegate(
      //             (BuildContext context, int index) {
      //               final bookTitle = newTestament[index];
      //
      //               return InkWell(
      //                 child: Container(
      //                   margin: const EdgeInsets.all(5.0),
      //                   padding: const EdgeInsets.symmetric(vertical: 5.0),
      //                   // color: bookSelected == bookTitle.key ? globalHighLightColor : null,
      //                   decoration: BoxDecoration(
      //                     shape: BoxShape.rectangle,
      //                     color: bookSelected == bookTitle.key ? themeColorShades[colorSliderIdx.value] : null,
      //                     borderRadius: const BorderRadius.all(Radius.circular(30.0)),
      //                   ),
      //                   alignment: Alignment.center,
      //                   child: Column(
      //                     children: [
      //                       Text(
      //                         bookTitle.key,
      //                         style: const TextStyle(
      //                           fontSize: 17,
      //                           fontWeight: FontWeight.w300,
      //                         ),
      //                       ),
      //                       Text(
      //                         bookTitle.val,
      //                         style: const TextStyle(
      //                             fontSize: 13,
      //                             // color: Colors.black54,
      //                             fontWeight: FontWeight.w400,
      //                             fontStyle: FontStyle.italic),
      //                       )
      //                     ],
      //                   ),
      //                 ),
      //                 onTap: () => {
      //                   bookSelected = bookTitle.key,
      //                   box.put('bookSelected', bookTitle.key),
      //                   selectedChapter = 1,
      //                   globalIndex.value = 1,
      //                   pages[0] = const ChapterSelectionPage(),
      //                   // BooksLocalPage(bibleVersions, bookTitle.key, selectedChapter,0),
      //                   barTitle.value = "Chapters",
      //                   // '$bookSelected $selectedChapter',
      //                   colorIndex = 999,
      //                 },
      //               );
      //             },
      //             childCount: newTestament.length,
      //           ),
      //         ))
      //   ],
      // );
}

  Widget buildListViewRow(oldT,newT) => Scaffold(
    body: FutureBuilder(
        // future: null,
        builder: (context, snapshot) {
          Future.delayed(Duration.zero, () => {
            if(bookOldNew == 'O'){
              itemScrollController.jumpTo(index: bookIdxSel ),
            }else{
              itemScrollController2.jumpTo(index: bookIdxSel )
            }
          });
          return Column(
            children: <Widget>[
              Card(
                child: SizedBox(
                  height: 35,
                  child: GridView.count(
                      crossAxisCount: 2,
                      children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(8),
                        color: themeColorShades[colorSliderIdx.value],
                        child: Text('Old Testament',textAlign: TextAlign.center, style: GoogleFonts.raleway(fontSize: 17.0,)),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        color: themeColorShades[colorSliderIdx.value],
                        child: Text('New Testament' ,textAlign: TextAlign.center, style: GoogleFonts.raleway(fontSize: 17.0,)),
                      ),
                    ]
                  )
                ),
              ),
              Expanded( child: Row(
                    children: [
                      Expanded(
                          child: ScrollablePositionedList.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: oldT.length,
                            itemBuilder: (context, index) {
                              final bookTitle = oldT[index];
                              return InkWell(
                                child: Container(
                                  margin: const EdgeInsets.all(4.0),
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: bookSelected == bookTitle.key ? themeColorShades[colorSliderIdx.value] : null,
                                    borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      Text( bookTitle.key, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w300,),),
                                      Text(bookTitle.val, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic),)
                                    ],
                                  ),
                                ),
                                onTap: () => {
                                  bookSelected = bookTitle.key,
                                  box.put('bookSelected', bookTitle.key),
                                  selectedChapter = 1,
                                  globalIndex.value = 1,
                                  pages[0] = const ChapterSelectionPage(),
                                  barTitle.value = "Chapters",
                                  colorIndex = 999,
                                  bookOldNew = 'O',
                                  bookIdxSel = index,
                                  box.put('bookOldNew', 'O'),
                                  box.put('bookIdxSel', index),
                                },
                              );
                            },
                            itemScrollController: itemScrollController,
                          )
                      ),
                      Expanded(
                          child: ScrollablePositionedList.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: newT.length,
                            itemBuilder: (context, index) {
                              final bookTitle = newT[index];
                              return InkWell(
                                child: Container(
                                  margin: const EdgeInsets.all(4.0),
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: bookSelected == bookTitle.key ? themeColorShades[colorSliderIdx.value] : null,
                                    borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      Text(bookTitle.key, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w300,),),
                                      Text(bookTitle.val, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic),)
                                    ],
                                  ),
                                ),
                                onTap: () => {
                                  bookSelected = bookTitle.key,
                                  box.put('bookSelected', bookTitle.key),
                                  selectedChapter = 1,
                                  globalIndex.value = 1,
                                  pages[0] = const ChapterSelectionPage(),
                                  barTitle.value = "Chapters",
                                  colorIndex = 999,
                                  bookOldNew = 'N',
                                  bookIdxSel = index,
                                  box.put('bookOldNew', 'N'),
                                  box.put('bookIdxSel', index),
                                },
                              );
                            },
                            itemScrollController: itemScrollController2,
                          )
                      ),
                    ],
                 )
              ),
             ]
          );
        }
    ),
  );