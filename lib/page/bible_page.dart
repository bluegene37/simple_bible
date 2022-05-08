import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:simple_bible/api/books_api.dart';
import 'package:simple_bible/model/books.dart';
import 'package:simple_bible/main.dart';

final ItemScrollController itemScrollController = ItemScrollController();

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
      future: selectedChapterHist != selectedChapter || bookSelectedHist != bookSelected ? BooksApi.getBooksLocally(context, jsonName, bookTitle, bookChapter) : null,
      builder: (context, snapshot) {

        final book = selectedChapterHist != selectedChapter || bookSelectedHist != bookSelected ? snapshot.data : bibleScreen;
        if(selectedChapterHist != selectedChapter){selectedChapterHist = selectedChapter;}
        if(bookSelectedHist != bookSelected){bookSelectedHist = bookSelected;}

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
        tileColor: selectedIdx.value ? themeColorShades[colorSliderIdx.value] : null,
        title: Text.rich(
          TextSpan(
            // text: 'Test',
            // style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(text: book.verse.toString()+'. ',
                  style: GoogleFonts.getFont(globalFont.value, fontSize: 11+fontSize.value,
                      color: globalTextColors[textColorIdx.value] ,
                      fontWeight: FontWeight.w300, fontStyle: FontStyle.italic ),
                ),
              TextSpan(text: book.text ,
                  style: GoogleFonts.getFont(globalFont.value, fontSize: 15+fontSize.value,
                      color: globalTextColors[textColorIdx.value] ,
                      // backgroundColor: Colors.greenAccent.shade100,
                  ),
              ),
            ],
          ),
        ),
        onTap: (){
          // selectedIdx.value = false;
        },
        onLongPress: (){
            showModalBottomSheet(
              context: context,
              builder: (context) => SizedBox(
                height: 100.0,
                child: highLighter(),
              ),
            );
          },
        )
      );
    },
    itemScrollController: itemScrollController,
    // itemPositionsListener: itemPositionsListener,
  );
}

// double mWidth = Dimens.height = MediaQuery.of(context).size.width;
// double mHeight = Dimens.height = MediaQuery.of(context).size.height;

Widget highLighter(){
  return ListView.separated(
    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
    scrollDirection: Axis.horizontal,
    itemCount: highLightColors.length,
    separatorBuilder: (context, index){
      return const SizedBox(width: 5);
    },
    itemBuilder: (context, index) {
      return InkWell(
        child: CircleAvatar(
          radius: 50 / 2,
          backgroundColor: highLightColors[index],
          // child: Icon(Icons.check, color: textColorDynamic.value) ,
        ),
        onTap: (){
          Navigator.pop(context);
        },
      );
    }
  );
}

var highLightColors = [
  Colors.red.shade100,
  Colors.pink.shade100,
  Colors.purple.shade100,
  Colors.indigo.shade100,
  Colors.blue.shade100,
  Colors.lightBlue.shade100,
  Colors.cyan.shade100,
  Colors.teal.shade100,
  Colors.green.shade100,
  Colors.lightGreen.shade100,
  Colors.lime.shade100,
  Colors.yellow.shade100,
  Colors.amber.shade100,
  Colors.orange.shade100,
  Colors.deepOrange.shade100,
  Colors.brown.shade100,
  Colors.blueGrey.shade100,
];