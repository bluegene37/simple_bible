import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outline_search_bar/outline_search_bar.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:simple_bible/main.dart';
import 'package:simple_bible/api/books_api.dart';
import 'package:simple_bible/model/books.dart';
import 'package:simple_bible/page/bible_page.dart';
import 'package:substring_highlight/substring_highlight.dart';
import 'package:intl/intl.dart';

var searchResults = [];
var searchIdxSel = 99999999.obs;
var hideHistory = false.obs;
var historyText = historyBox.values.toList().obs;
var historyKeys = historyBox.keys.toList().obs;
var txt = TextEditingController();
var focusNode = FocusNode();

class SearchLocalPage extends StatelessWidget {
  const SearchLocalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(focusNode);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Obx(() => Stack(
        fit: StackFit.loose,
        children: [
          hideHistory.value ? Obx(() => SearchResultPage(searchQueryMain.value)) : const HistoryPage(),
          Obx(() => OutlineSearchBar(
              focusNode: focusNode ,
              clearButtonColor: colorSliderIdx.value == 0 ? globalTextColors[textColorIdx.value] : themeColors[colorSliderIdx.value],
              cursorColor: colorSliderIdx.value == 0 || colorSliderIdx.value == 1 ? globalTextColors[textColorIdx.value] : themeColors[colorSliderIdx.value],
              searchButtonIconColor: colorSliderIdx.value == 0 || colorSliderIdx.value == 1 ? globalTextColors[textColorIdx.value] : themeColors[colorSliderIdx.value],
              borderColor: colorSliderIdx.value == 0 || colorSliderIdx.value == 1 ? globalTextColors[textColorIdx.value] : themeColors[colorSliderIdx.value],
              margin: const EdgeInsets.all(8.0),
              textEditingController: txt,
              initText: searchQueryMain.value,
              hintText: 'Search here...',
              onSearchButtonPressed: (query) => {
                searchQueryMain.value = query,
                hideHistory.value = true,
                if(query.isNotEmpty){
                  if(historyBox.values.contains(query)){
                      historyBox.toMap().forEach((key, value){
                          if(value == query) {
                            historyBox.delete(key);
                          }
                      }),
                    historyBox.put(DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()), query),
                  }else{
                    historyBox.put(DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()), query),
                  }
                }
              },
              onClearButtonPressed: (query) => {
                searchQueryMain.value = '',
                searchIdxSel.value = 99999999,
                barTitle.value = "Search",
                hideHistory.value = false
              },
              onKeywordChanged: (query) => {
                if(query.isEmpty){
                searchQueryMain.value = query,
              }
            },
          )
          ),
        ],
        )
      )
    );
  }
}

class SearchResultPage extends StatelessWidget {
  final String searchQuery;
  const SearchResultPage(this.searchQuery);

  @override
  Widget build(BuildContext context) => Scaffold(
    body: FutureBuilder<List<Book>>(
      future: searchResultHist != searchQueryMain.value && searchQueryMain.isNotEmpty ? SearchApi.getBooksLocally(context, bibleVersions, searchQuery) : null,
      builder: (context, snapshot) {
        if(searchResultHist != searchQueryMain.value){searchResultHist = searchQueryMain.value;}
        searchResults = searchResultHist != searchQueryMain.value ? snapshot.data! : searchScreen;

        Future.delayed(Duration.zero, () => {
        if(searchIdxSel < 99999999){
            itemScrollController.jumpTo(index: searchIdxSel.value)
          }
        });
        if(searchResults.isNotEmpty){
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            default:
              if(snapshot.hasError) {
                return Center(child: Container(
                padding: const EdgeInsets.all(15.0),
                  child: Text('No Result for: $searchQueryMain', style: const TextStyle(fontSize: 20) ),
                  ),
                );
              }else{
                if(searchQueryMain.value.isNotEmpty && searchResults.isNotEmpty){
                  Future.delayed(Duration.zero,(){
                    barTitle.value =  'Search result: ${searchResults.length}';
                  });
                  return buildSearchResult(searchResults);
                }else{
                  Future.delayed(Duration.zero,(){
                    barTitle.value = 'Search';
                  });
                  return const Center(child: Text(' '));
                }
              }
          }
        }else{
          if(searchQueryMain.value.isNotEmpty) {
            Future.delayed(Duration.zero, () {
              barTitle.value = 'Search';
            });
            return Center(child: Container(
              padding: const EdgeInsets.all(15.0),
              child: Text('No Result for: $searchQueryMain', style: const TextStyle(fontSize: 20) ),
            )
            );
          }else{
            return const Center(child: Text(' '));
          }
        }
      },
    ),
);

  Widget buildSearchResult(books) => Container(
    margin: const EdgeInsets.only(top:59.0),
    child: ScrollablePositionedList.builder(
    physics: const BouncingScrollPhysics(),
    itemCount: books.length,
    padding: const EdgeInsets.only(top: 10.0),
    itemBuilder: (context, index) {
      final book = books[index];
      var tileSelected = false.obs;
      if(searchIdxSel < 99999999){
        tileSelected.value = index == searchIdxSel.value ? true : false;
      }

      return Card (
          child: Obx(() => ListTile(
          selected: tileSelected.value,
          selectedTileColor: themeColorShades[colorSliderIdx.value],
          title: SubstringHighlight(text: book.book+' '+book.chapter.toString()+':'+book.verse.toString() ,term: searchQueryMain.value,
              textStyle: TextStyle(
                  fontSize: 15,
                  color: globalTextColors[textColorIdx.value],
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic
              ),
              textStyleHighlight: TextStyle(
                  color: colorSliderIdx.value == 0 || colorSliderIdx.value == 1 ? globalTextColors[textColorIdx.value] : themeColors[colorSliderIdx.value],
                  fontSize: 18 , fontWeight: FontWeight.w500, fontStyle: FontStyle.italic
              ),
          ),

          subtitle: SubstringHighlight(text: book.text ,term: searchQueryMain.value,
              textStyle: TextStyle(
                  fontSize: 17,
                  color: globalTextColors[textColorIdx.value],
                  fontWeight: FontWeight.w300),
                  textStyleHighlight: TextStyle(
                      color: colorSliderIdx.value == 0 || colorSliderIdx.value == 1 ? globalTextColors[textColorIdx.value] : themeColors[colorSliderIdx.value],
                      fontSize: 18 , fontWeight: FontWeight.w500, fontStyle: FontStyle.italic),
          ),
          onTap: (){
              bookSelected = book.book;
              selectedChapter = book.chapter;
              globalIndex.value = 2;
              pages[0] = BooksLocalPage(bibleVersions, book.book,book.chapter, book.verse - 1);
              barTitle.value = book.book +' '+book.chapter.toString();
              colorIndex = book.verse - 1;
              searchIdxSel.value = index;
            },
          )
          )
        );
      },
      itemScrollController: itemScrollController,
    )
  );
}

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    body: FutureBuilder(
      future: null,
      builder: (context, snapshot) {
          historyText.value = historyBox.values.toList().obs;
          historyKeys.value = historyBox.keys.toList().obs;
        return Column(
          children: [
            Container(
                margin: const EdgeInsets.only(top:65.0),
                padding: const EdgeInsets.all(5.0),
                child: Center(child: Text( historyText.value.isNotEmpty ? 'Search History:'  : 'Search History: None', style: const TextStyle(fontSize: 18.0),),
              ),
            ),
            Expanded(
              child: Obx(() => ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: historyKeys.value.length,
                itemBuilder: (context, index) {
                  if(index > 25){
                    historyBox.delete(historyKeys.value[historyKeys.value.length - 1 -index]);
                  }
                  return Card(
                    child: ListTile(
                      title: Text(historyText.value[historyText.value.length - 1 -index]),
                      subtitle: Text(historyKeys.value[historyKeys.value.length - 1 -index]),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          historyBox.delete(historyKeys.value[historyText.value.length - 1 -index]);
                          historyText.value = historyBox.values.toList().obs;
                          historyKeys.value = historyBox.keys.toList().obs;
                        },
                      ),
                      onTap: (){
                        searchQueryMain.value = '';
                        searchIdxSel.value = 99999999;
                        barTitle.value = "Search";
                        hideHistory.value = false;

                        searchQueryMain.value = historyText.value[historyText.value.length - 1 -index];
                        txt.text = historyText.value[historyText.value.length - 1 -index];
                        hideHistory.value = true;
                      },
                    ),
                  );
                },
              )
              ),
            )
          ],
        );
      }
    ),
  );
}
