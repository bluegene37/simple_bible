import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../main.dart';
import 'bible_page.dart';

var hiLightText = hiLightBox.values.toList();
var hiLightKeys = hiLightBox.keys.toList();
var jsonTexts = textsBox.values.toList();
var jsonKeys = textsBox.keys.toList();
var notesText = notesBox.values.toList();
var notesKeys = notesBox.keys.toList();
var hiLightVerses = textsBox.values.toList();
var notesHiLights = 1.obs;

class NotesHLScreen extends StatelessWidget {
  const NotesHLScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Future.delayed(Duration.zero, () => {
      barTitle.value = 'Notes | Highlights',
    });

    return Column(
      children: [
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: themeColorShades[colorSliderIdx.value],
          ),
          // ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Obx(() => Row(
                // alignment: WrapAlignment.spaceAround,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly ,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: notesHiLights.value == 2 ? themeColors[colorSliderIdx.value] : themeColorShades[colorSliderIdx.value] ,
                      onPrimary: textColorDynamic.value,
                      textStyle: const TextStyle(fontSize: 20,),
                    ),
                    onPressed: () {
                      notesHiLights.value = 2;
                    },
                    child: const Text('Notes'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: notesHiLights.value == 1 ? themeColors[colorSliderIdx.value] : themeColorShades[colorSliderIdx.value] ,
                      onPrimary: textColorDynamic.value,
                      textStyle: const TextStyle(fontSize: 20,),
                    ),
                    onPressed: () {
                      notesHiLights.value = 1;
                    },
                    child: const Text('Highlights'),
                  ),
                ],
                ),
              ),
            ],
          ),
        ),
        Obx(() => Expanded(
            child: notesHiLights.value == 1 ? const HiLightPage() : const NotesPage()
        )
        )
      ],
    );
  }
}


class HiLightPage extends StatelessWidget {
  const HiLightPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    // key: const PageStorageKey<String>('page'),
    body: FutureBuilder(
        future: null,
        builder: (context, snapshot) {
          hiLightText = hiLightBox.values.toList();
          hiLightKeys = hiLightBox.keys.toList();
          jsonTexts = textsBox.values.toList();
          jsonKeys = textsBox.keys.toList();

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: hiLightKeys.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text.rich(
                            TextSpan(
                                children: <TextSpan>[
                                  TextSpan(text:  " ${jsonKeys[index]} - ${jsonTexts[index]['version']} ", style: const TextStyle(color: Colors.black54, fontSize: 13, fontStyle: FontStyle.italic)),
                                  const TextSpan(text: '\n'),
                                  TextSpan(text: jsonTexts[index]['text'], style: TextStyle(color: brightness == Brightness.dark ?  Colors.black54 : Colors.black)),
                                  const TextSpan(text: '\n' ),
                                  TextSpan(text: jsonTexts[index]['datetime'], style: const TextStyle(color: Colors.black54, fontSize: 13, fontStyle: FontStyle.italic)),
                                ]
                            )
                        ),
                        tileColor: highLightColors[jsonTexts[index]['color']],
                        onTap: (){
                          final bookTitle = jsonKeys[index].split(':')[0];
                          final bookChapter = int.parse(jsonKeys[index].split(':')[1]);
                          final bookVerse = int.parse(jsonKeys[index].split(':')[2]);

                          bookSelected = bookTitle;
                          box.put('bookSelected', bookTitle);
                          selectedChapter = bookChapter;
                          if(bookSelected != bookSelectedHist){
                            refreshChapter = true;
                          }
                          globalIndex.value = 2;
                          pages[0] = BooksLocalPage(bibleVersions, bookTitle ,bookChapter, bookVerse - 1);
                          barTitle.value = bookTitle +' '+bookChapter.toString();
                          // colorIndex = bookVerse - 1;
                          // searchIdxSel.value = index;
                        },
                      ),
                    );
                  },
                ),
              )
            ],
          );
        }
    ),
  );
}

class NotesPage extends StatelessWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    // key: const PageStorageKey<String>('page'),
    body: FutureBuilder(
        future: null,
        builder: (context, snapshot) {
          notesText = notesBox.values.toList();
          notesKeys = notesBox.keys.toList();
          // notesBox.clear();
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount:notesText.length,
                  itemBuilder: (context, index) {
                  var vNotesJson = notesText[index];
                  var finalText = vNotesJson['book'].replaceAll('[','').replaceAll(']','').split(",");
                  var finalVerse = '';
                  var removeTexts = [];
                  finalText.asMap().forEach((index, verse) => {
                    removeTexts = verse.split(':'),
                    finalVerse = index == 0 ? finalText[0] : '$finalVerse, ${removeTexts.last}' ,
                  });

                    return Card(
                      child: ListTile(
                        // leading: Text(vNotesJson['book']),
                        // tileColor: Colors.grey.shade100,
                        trailing: FaIcon(FontAwesomeIcons.ellipsisVertical, color: themeColors[colorSliderIdx.value]),
                        title: Text.rich(
                            TextSpan(
                              // text: vNotesJson['book'],
                              // style: const TextStyle(color: Colors.black54, fontStyle: FontStyle.italic),
                                children: <TextSpan>[
                                  TextSpan(text: '$finalVerse - $bibleVersions', style: TextStyle(color: globalTextColors[textColorIdx.value], fontSize: 13, fontStyle: FontStyle.italic)),
                                  const TextSpan(text: '\n\n'),
                                  TextSpan(text: "  ${vNotesJson['notes']}", style: TextStyle(color: globalTextColors[textColorIdx.value])),
                                  const TextSpan(text: '\n\n'),
                                  TextSpan(text: vNotesJson['stamp'], style: TextStyle(color: globalTextColors[textColorIdx.value], fontSize: 13, fontStyle: FontStyle.italic)),
                                ]
                            )
                        ),
                        onTap: (){
                          final bookTitle = notesKeys[index].split(':')[0];
                          final bookChapter = int.parse(notesKeys[index].split(':')[1]);
                          final bookVerse = int.parse(notesKeys[index].split(':')[2]);

                          bookSelected = bookTitle;
                          box.put('bookSelected', bookTitle);
                          selectedChapter = bookChapter;
                          if(bookSelected != bookSelectedHist){
                            refreshChapter = true;
                          }
                          globalIndex.value = 2;
                          pages[0] = BooksLocalPage(bibleVersions, bookTitle ,bookChapter, bookVerse - 1);
                          barTitle.value = bookTitle +' '+bookChapter.toString();
                        },
                      ),
                    );
                  },
                ),
              )
            ],
          );
        }
    ),
  );
}