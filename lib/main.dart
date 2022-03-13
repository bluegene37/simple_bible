import 'package:flutter/material.dart';
import 'package:simple_bible/page/search_page.dart';
import 'package:simple_bible/page/settings_page.dart';
import 'package:simple_bible/page/books_page.dart';
import 'package:simple_bible/page/chapter_page.dart';
import 'package:simple_bible/page/bible_page.dart';

var pages = [];
var mainBooks;
var mainBooksMenu;
var bibleVersions = 'kjv';
var barTitle = 'Books';
var bookSelected = 'Genesis';
int selectedChapter = 1;
int lastChapter = 1;
var shouldShowLeft = true;
var shouldShowRight = true;

void main() {
  pages = [BooksSelectionPage()];
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch:  Colors.teal,
      ),
      home: const MyHomePage(
        title:'Simple Bible',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void initState(){
    super.initState();
    init();
  }

  Future init() async {
    final assetBundle = DefaultAssetBundle.of(context);
    mainBooksMenu = await assetBundle.loadString('assets/booktitle.json');
    mainBooks = await assetBundle.loadString('assets/'+bibleVersions+'.json');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(35.0), // here the desired height
        child:  AppBar(
            leading: Container(),
            centerTitle: true,
            title: Text(barTitle),
          )
      ),
      key: _key,
      body: pages[0],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          // indicatorColor: Colors.blue.shade100,
          labelTextStyle: MaterialStateProperty.all(
            TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          )
        ),
        child: NavigationBar(
          height: 60,
          selectedIndex: _currentIndex,
          onDestinationSelected: (_currentIndex) =>
            {
              setState(() => {
                  this._currentIndex = _currentIndex,
                }
              ),
              if (this._currentIndex == 0) {
                barTitle = "Books",
                // preferences.setString('bookSelected',bookSelected),
                pages[0] = BooksSelectionPage()
              } else if (this._currentIndex == 1) {
                barTitle = "Chapters",
                pages[0] = ChapterSelectionPage()
              } else if (this._currentIndex == 2) {
                pages[0] = BooksLocalPage(bibleVersions, bookSelected, selectedChapter),
                barTitle = bookSelected +' '+selectedChapter.toString()
              } else if (this._currentIndex == 3) {
                barTitle = "Search",
                pages[0] = SearchLocalPage()
              } else if (this._currentIndex == 4) {
                barTitle = "Settings",
                pages[0] = SettingsLocalPage()
              } else {
                pages[0] = BooksLocalPage(bibleVersions, bookSelected, selectedChapter),
              }
          },
          destinations: [
            NavigationDestination(
                icon: Icon(Icons.book_outlined),
                label: 'Books'
            ),
            NavigationDestination(
                icon: Icon(Icons.menu_outlined),
                label: 'Chapters'
            ),
            NavigationDestination(
                icon: Icon(Icons.menu_book_outlined),
                label: 'Bible'
            ),
            NavigationDestination(
                icon: Icon(Icons.search),
                label: 'Search'
            ),
            NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                label: 'Settings'
            ),
          ],
        ),
      )
    );
  }
}

