import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:simple_bible/api/books_api.dart';
import 'package:simple_bible/model/books.dart';
import 'package:simple_bible/main.dart';

final ItemScrollController itemScrollController = ItemScrollController();
// final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

var shadeIdx = 8;
var colorFade = const Color(0xfffbc02d).obs;

class BooksLocalPage extends StatelessWidget {
  final String jsonName;
  final String bookTitle;
  final int bookChapter;
  final int jumpTo;

  const BooksLocalPage(this.jsonName,this.bookTitle, this.bookChapter, this.jumpTo );

  void jumpToFunc() =>  itemScrollController.jumpTo(index: jumpTo);

  @override
  Widget build(BuildContext context) => Scaffold(
    body: FutureBuilder<List<Book>>(
      future: selectedChapterHist != selectedChapter && bookSelectedHist != bookSelected ? BooksApi.getBooksLocally(context, jsonName, bookTitle, bookChapter) : null,
      builder: (context, snapshot) {

        final book = selectedChapterHist != selectedChapter && bookSelectedHist != bookSelected ? snapshot.data : bibleScreen;
        if(selectedChapterHist != selectedChapter){selectedChapterHist = selectedChapter;}

        // WidgetsBinding.instance?.addPostFrameCallback((_) => Future.delayed(Duration.zero, () => jumpToFunc() ) );
        Future.delayed(Duration.zero, () => {
              jumpToFunc(),
            //   if(colorIndex < 999){
            //       shadeIdx = 8,
            //       colorFade.value = Color(shadesList[8]),
            //   Timer.periodic(const Duration(seconds: 2), (timer) =>
            //   {
            //     if(shadeIdx > 0){shadeIdx--},
            //     colorFade.value = Color(shadesList[shadeIdx]),
            //     if(shadeIdx < 1 || shadeIdx == 0){
            //       timer.cancel(),
            //     },
            //   }),
            // }
          }
        );

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
  );


  Widget buildBooks(books) => ScrollablePositionedList.builder(
    physics: const BouncingScrollPhysics(),
    padding: const EdgeInsets.only(top: 10.0),
    itemCount: books.length,
    itemBuilder: (context, index) {
      final book = books[index];
      var selectedIdx = false.obs;
      selectedIdx.value = index == colorIndex ? true : false;

      return Obx(() => ListTile(
        // tileColor: selectedIdx.value ? colorFade.value : null,
        tileColor: selectedIdx.value ? globalHighLightColor : null,
        title: RichText(
          text: TextSpan(
            // text: book.verse.toString()+' ',
            // style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(text: book.verse.toString()+'. ',
                  style: TextStyle(
                      fontSize: 13,
                      color: globalTextColor,
                      // fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic)
              ),
              TextSpan(text: book.text ,
                  style: TextStyle(
                      fontSize: 17,
                      color: globalTextColor,
                      // fontFamily: 'Roboto',
                      fontWeight: FontWeight.w300)
              ),
            ],
          ),
        ),
        onTap: (){

        },
      )
      );
    },
    itemScrollController: itemScrollController,
    // itemPositionsListener: itemPositionsListener,
  );
}

