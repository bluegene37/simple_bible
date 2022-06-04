import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:simple_bible/api/books_api.dart';
import 'package:simple_bible/model/books.dart';
import 'package:simple_bible/main.dart';

final ItemScrollController itemScrollController = ItemScrollController();
var textUnderline = [].obs;
var shadeIdx = 8;
var colorFade = const Color(0xfffbc02d).obs;
var highlightSelected = [];
var highlightClear = [];
var bottomPadding = 0.0.obs;
var copyTextClipboard = '';
var copyTextByVerse = [];

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
              Navigator.of(context).maybePop(),
              textUnderline.value = [],

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
              return Obx(() =>buildBooks(book!) );
            }
        }

      },
    ),
  );

  Widget buildBooks(books) => ScrollablePositionedList.builder(
    physics: const BouncingScrollPhysics(),
    padding: EdgeInsets.only(top: 10.0, bottom: bottomPadding.value ),
    itemCount: books.length,
    itemBuilder: (context, index) {
      final book = books[index];

      return Obx(() => ListTile(
        tileColor: colorIndex == index ? themeColorShades[colorSliderIdx.value] : null,
        title: Text.rich(
          TextSpan(
            // text: 'Test',
            // style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(text: '${book.verse}. ',
                  style: GoogleFonts.getFont(globalFont.value, fontSize: 11+fontSize.value,
                      color: globalTextColors[textColorIdx.value] ,
                      fontWeight: FontWeight.w300, fontStyle: FontStyle.italic ),
                ),
              TextSpan(
                  text: book.text ,
                  recognizer: TapGestureRecognizer()..onTap = () {
                      if(textUnderline.contains(book.id+book.chapter.toString()+book.verse.toString())){
                        textUnderline.remove(book.id+book.chapter.toString()+book.verse.toString());
                        highlightSelected.remove(box.get(book.id+book.chapter.toString()+book.verse.toString()+'color'));
                        highlightClear.remove(book.id+book.chapter.toString()+book.verse.toString()+box.get(book.id+book.chapter.toString()+book.verse.toString()+'color').toString());
                        // copyTextClipboard = copyTextClipboard.replaceAll(book.text, "");
                        copyTextByVerse.remove(book.verse);
                      }else{
                        textUnderline.add(book.id+book.chapter.toString()+book.verse.toString());
                        highlightSelected.add(box.get(book.id+book.chapter.toString()+book.verse.toString()+'color'));
                        highlightClear.add(book.id+book.chapter.toString()+book.verse.toString()+box.get(book.id+book.chapter.toString()+book.verse.toString()+'color').toString());
                        // copyTextClipboard = '$copyTextClipboard '+book.text;
                        copyTextByVerse.add(book.verse);
                      }

                    if(textUnderline.isNotEmpty){
                      bottomPadding.value = 120.0;
                      final PersistentBottomSheetController bottomSheetController = Scaffold.of(context).showBottomSheet<void>(
                        (BuildContext context) {
                          return  Padding(
                            padding: const EdgeInsets.only(
                                // bottom: MediaQuery.of(context).viewInsets.bottom
                                left: 10.0, right: 10.0
                            ),
                            child: SizedBox(
                                height: 120,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      const SizedBox(
                                        height: 10,
                                        width: 70,
                                        child: Divider(
                                          thickness: 3,
                                          color: Colors.grey
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      SizedBox(
                                        height: 30,
                                        child: copyBtn(),
                                      ),
                                      SizedBox(
                                        height: 70,
                                        child: highLighter(),
                                      )
                                    ],
                                  ),
                                )
                            ),
                          );
                        },
                      );
                      bottomSheetController.closed.then((value) {
                        bottomPadding.value = 0.0;
                        textUnderline.value = [];
                        highlightSelected = [];
                        highlightClear = [];
                        copyTextClipboard = '';
                      });
                    }else{
                      bottomPadding.value = 0.0;
                      Navigator.pop(context);
                    }
                  },
                  style: GoogleFonts.getFont(globalFont.value, fontSize: 15+fontSize.value,
                      color: !box.containsKey(book.id+book.chapter.toString()+book.verse.toString()+'color') && brightness == Brightness.dark ?  globalTextColors[textColorIdx.value] : Colors.black ,
                      decoration: textUnderline.value.contains(book.id+book.chapter.toString()+book.verse.toString()) ? TextDecoration.underline : null,
                      decorationStyle: textUnderline.value.contains(book.id+book.chapter.toString()+book.verse.toString()) ? TextDecorationStyle.dashed : null,
                      backgroundColor: !box.containsKey(book.id+book.chapter.toString()+book.verse.toString()+'color')
                          ? null
                          : highLightColors[box.get(book.id+book.chapter.toString()+book.verse.toString()+'color',defaultValue: 0)],
                  ),
                ),
            ],
          ),
        ),
        onTap: (){

        },
        onLongPress: (){

        },
      )
    );
  },
  itemScrollController: itemScrollController,
    // itemPositionsListener: itemPositionsListener,
  );

}



Widget copyBtn(){
  return Row(
    children: [
      const Spacer(),
      ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: themeColors[colorSliderIdx.value],
          ),
          child: Text('Copy selected text' , style: TextStyle( color: textColorDynamic.value),),
          onPressed: () {
            copyTextClipboard = '';
            for (var i in bibleScreen) {
              if(copyTextByVerse.contains(i.verse) ){
                copyTextClipboard = '$copyTextClipboard ${i.text}';
                Get.snackbar('', 'Copied!');
              }
            }

            Clipboard.setData(
              ClipboardData(text: copyTextClipboard ),
            );
          }),
      const Spacer(),
      ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: themeColors[colorSliderIdx.value],
          ),
          child: Text('Copy w/ verse(s)' , style: TextStyle( color: textColorDynamic.value),),
          onPressed: () {
            copyTextClipboard = '';
            for (var i in bibleScreen) {
              if(copyTextByVerse.contains(i.verse) ){
                copyTextClipboard = '$copyTextClipboard ${i.verse}${'.'} ${i.text}';
                Get.snackbar('', 'Copied');
              }
            }
            Clipboard.setData(
              ClipboardData(text: copyTextClipboard ),
            );
          }),
      const Spacer(),
    ],
  );
}

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
                radius: 45 / 2,
                backgroundColor: highLightColors[index],
                child: highlightSelected.contains(index) ? const Icon(Icons.close, color: Colors.black) : null,
              ),
              onTap: (){
                Navigator.pop(context);
                for (var uniqueKey in textUnderline) {
                  if(highlightClear.contains(uniqueKey+index.toString())){
                    box.delete(uniqueKey+'color');
                  }
                  if(!highlightSelected.contains(index)){
                    box.put(uniqueKey+'color', index);
                  }
                }
                textUnderline.value = [];
                highlightSelected = [];
                highlightClear = [];
                copyTextClipboard = '';
              },
            );
          }
      );
  }

