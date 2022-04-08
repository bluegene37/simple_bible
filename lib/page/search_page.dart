import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outline_search_bar/outline_search_bar.dart';
import 'package:simple_bible/main.dart';
import 'package:simple_bible/api/books_api.dart';
import 'package:simple_bible/model/books.dart';
import 'package:simple_bible/page/bible_page.dart';
import 'package:substring_highlight/substring_highlight.dart';

var searchQueryMain = ''.obs;

class SearchLocalPage extends StatelessWidget {
  const SearchLocalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.loose,
        children: [
        Obx(() => SearchResultPage(searchQueryMain.value)),
        OutlineSearchBar(
        margin: const EdgeInsets.all(8.0),
        initText: searchQueryMain.value,
        hintText: 'Search here...',
        onSearchButtonPressed: (query) => {
            searchQueryMain.value = query,
          },
        onClearButtonPressed: (query) => {
            searchQueryMain.value = '',
          },
        onKeywordChanged: (query) => {
          if(query.isEmpty){
            searchQueryMain.value = query,
          }
          },
        ),
      ],
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
      future: SearchApi.getBooksLocally(context, bibleVersions, searchQuery),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          final searchResults = snapshot.data!;
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            default:
              if(snapshot.hasError) {
                return const Center(child: Text('No Search Result!'));
              }else{
                if(searchQueryMain.value.isNotEmpty && searchResults.isNotEmpty){
                  Future.delayed(Duration.zero,(){
                    barTitle.value =  'Search result: '+ searchResults.length.toString();
                  });
                  return buildSearchResult(searchResults);
                }else if(searchQueryMain.value.isNotEmpty && searchResults.isEmpty ){
                  Future.delayed(Duration.zero,(){
                    barTitle.value = 'Search';
                  });
                  return Center(child: Text('No Result for: $searchQueryMain'));
                }else{
                  Future.delayed(Duration.zero,(){
                    barTitle.value = 'Search';
                  });
                  return const Center(child: Text(' '));
                }
              }
          }
        }else{
          return const Center(child: Text(' '));
        }
      },
    ),
);


  Widget buildSearchResult(List<Book> books) => Container(
    margin: const EdgeInsets.only(top:50),
    child: ListView.builder(
    physics: const BouncingScrollPhysics(),
    itemCount: books.length,
    padding: const EdgeInsets.only(top: 10.0),
    itemBuilder: (context, index) {
      final book = books[index];

      return Card (
          child: ListTile(
          title: SubstringHighlight(text: book.book+' '+book.chapter.toString()+':'+book.verse.toString() ,term: searchQueryMain.value, textStyle: const TextStyle(fontSize: 15, color: Colors.black,fontFamily: 'Roboto',fontWeight: FontWeight.w400, fontStyle: FontStyle.italic)),
          subtitle: SubstringHighlight(text: book.text ,term: searchQueryMain.value, textStyle: const TextStyle( fontSize: 17, color: Colors.black87, fontFamily: 'Roboto', fontWeight: FontWeight.w300)),
          onTap: (){
              bookSelected = book.book;
              selectedChapter = book.chapter;
              globalIndex.value = 2;
              pages[0] = BooksLocalPage(bibleVersions, book.book, book.chapter,book.verse > 4 ? book.verse - 4 : book.verse - 1);
              barTitle.value = book.book +' '+book.chapter.toString();
              colorIndex = book.verse - 1;
            },
          )
        );
      },
    )
  );
}
