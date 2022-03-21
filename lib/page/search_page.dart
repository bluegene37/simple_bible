import 'package:flutter/material.dart';
import 'package:simple_bible/main.dart';
import 'package:simple_bible/api/books_api.dart';
import 'package:simple_bible/model/books.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';


class SearchLocalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // This is handled by the search bar itself.
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          buildFloatingSearchBar(context),
          // SearchResultPage('Adam'),

        ],
      ),
    );
  }

}

Widget buildFloatingSearchBar(context) {
  final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

  return FloatingSearchBar(
    hint: 'Search...',
    scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
    transitionDuration: const Duration(milliseconds: 800),
    transitionCurve: Curves.easeInOut,
    physics: const BouncingScrollPhysics(),
    axisAlignment: isPortrait ? 0.0 : -1.0,
    openAxisAlignment: 0.0,
    width: isPortrait ? 600 : 500,
    debounceDelay: const Duration(milliseconds: 500),
    onQueryChanged: (query) {
      // Call your model, bloc, controller here.
      SearchResultPage(query);
    },
    // onSubmitted: (query) {
    //     SearchResultPage(query);
    //   },
    // Specify a custom transition to be used for
    // animating between opened and closed stated.
    transition: CircularFloatingSearchBarTransition(),
    actions: [
      FloatingSearchBarAction(
        showIfOpened: false,
        child: CircularButton(
          icon: const Icon(Icons.book_outlined),
          onPressed: () {},
        ),
      ),
      // FloatingSearchBarAction.searchToClear(
      //   showIfClosed: false,
      // ),
    ],
    builder: (context, transition) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Material(
          color: Colors.white,
          elevation: 4.0,
          child:
          Column(
            // mainAxisSize: MainAxisSize.min,
            // children: Colors.accents.map((color) {
            //   return Container(height: 112, color: color);
            // }).toList(),
          ),
        ),
      );
    },
  );
}



class SearchResultPage extends StatelessWidget {
  final String searchQuery;

  const SearchResultPage(this.searchQuery);

  @override
  Widget build(BuildContext context) => Scaffold(
    body: FutureBuilder<List<Book>>(
      future: SearchApi.getBooksLocally(context, bibleVersions, searchQuery),
      builder: (context, snapshot) {
        final book = snapshot.data;
        barTitle = bookSelected +' '+selectedChapter.toString();
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
            return Center(child: CircularProgressIndicator());
          default:
            if(snapshot.hasError) {
              return Center(child: Text('Some error occurred!'));
            } else {
              return buildBooks(book!);
            }
        }
      },
    ),

  );

  Widget buildBooks(List<Book> books) => ListView.builder(
    physics: BouncingScrollPhysics(),
    itemCount: books.length,
    padding: EdgeInsets.only(top: 10.0),
    itemBuilder: (context, index) {
      final book = books[index];

      return ListTile(
        title: RichText(
          text: TextSpan(
            // text: book.verse.toString()+' ',
            // style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(text: book.verse.toString()+' ' ,
                  style: TextStyle( fontSize: 13, color: Colors.black,fontFamily: 'Roboto',fontWeight: FontWeight.w400, fontStyle: FontStyle.italic)),
              TextSpan(text: book.text , style: TextStyle( fontSize: 17, color: Colors.black87, fontFamily: 'Roboto', fontWeight: FontWeight.w300)),
            ],
          ),
        ),
        onTap: (){

        },
      );
    },
  );

}