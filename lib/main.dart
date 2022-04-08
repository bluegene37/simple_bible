import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_bible/page/search_page.dart';
import 'package:simple_bible/page/settings_page.dart';
import 'package:simple_bible/page/books_page.dart';
import 'package:simple_bible/page/chapter_page.dart';
import 'package:simple_bible/page/bible_page.dart';

var pages = [];
var mainBooks = '';
var mainBooksMenu = '';
var bibleVersions = 'kjv';
var barTitle = 'Simple Bible'.obs;
var bookSelected = 'Genesis';
int selectedChapter = 1;
int lastChapter = 1;
var shouldShowLeft = true;
var shouldShowRight = true;
var globalIndex = 2.obs;
var colorIndex = 999;

void main() {
  pages = [BooksLocalPage(bibleVersions, bookSelected, selectedChapter, 0)];
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
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
  // int _currentIndex = 2;
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void initState(){
    super.initState();
    init();
  }

  Future init() async {
    barTitle.value = bookSelected +' '+selectedChapter.toString();
  }

  void onTabTapped(index) {
    setState(() {
      globalIndex.value = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(35.0), // here the desired height
        child:  AppBar(
            leading: Container(),
            centerTitle: true,
            title: Text(barTitle.value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
              ),
            ),
          )
      ),
      key: _key,
      body: SafeArea(child: pages[0]),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          // indicatorColor: Colors.blue.shade100,
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          )
        ),
        child: NavigationBar(
          height: 60,
          selectedIndex: globalIndex.value,
          onDestinationSelected: (globalIndex) => {
              onTabTapped(globalIndex),
              if (globalIndex == 0) {
                barTitle.value = "Books",
                pages[0] = const BooksSelectionPage()
              } else if (globalIndex == 1) {
                barTitle.value = "Chapters",
                pages[0] = const ChapterSelectionPage()
              } else if (globalIndex == 2) {
                pages[0] = BooksLocalPage(bibleVersions, bookSelected, selectedChapter, 0),
                barTitle.value = bookSelected +' '+selectedChapter.toString()
              } else if (globalIndex == 3) {
                barTitle.value = "Search",
                pages[0] = const SearchLocalPage()
              } else if (globalIndex == 4) {
                barTitle.value = "Settings",
                pages[0] = const SettingsLocalPage()
              } else {
                pages[0] = BooksLocalPage(bibleVersions, bookSelected, selectedChapter,0),
              }
          },
          destinations: const [
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
    )
    );
  }
}

