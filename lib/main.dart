import 'package:adaptive_theme/adaptive_theme.dart';
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
var bookSelectedHist = '';
var bookSelected = 'Genesis';
int selectedChapterHist = 0;
int selectedChapter = 1;
int lastChapter = 1;
var searchResultHist = '';
var searchQueryMain = ''.obs;
var shouldShowLeft = true;
var shouldShowRight = true;
var globalIndex = 2.obs;
var colorIndex = 999;
var globalColor = Colors.blue.shade100.obs;
var globalColorShade = Colors.blue.shade100;
var globalTextColor = Colors.black.obs;
var globalSearchColor = Colors.red;
var globalHighLightColor = globalColor.value;
var shadesList = [0xfffafafa,0xfffffde7,0xfffff9c4,0xfffff59d,0xfffff176,0xffffee58,0xffffeb3b,0xfffdd835,0xfffbc02d];
var globalFont = 'Roboto'.obs;
var fontSize = 2.0.obs;
var chaptersScreen = [];
var bibleScreen = [];
var searchScreen = [];

void main() {
  pages = [BooksLocalPage(bibleVersions, bookSelected, selectedChapter, 0)];
    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
        light: ThemeData(
          brightness: Brightness.light,
          primaryColor: globalColor.value,
          fontFamily: globalFont.value,
        ),
        dark: ThemeData(
          brightness: Brightness.dark,
          primaryColor: globalColor.value,
          fontFamily: globalFont.value,
        ),
        initial: AdaptiveThemeMode.light,
        builder: (theme, darkTheme) => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          darkTheme: darkTheme,
          home: const MyHomePage(
            title:'Simple Bible',
          ),
        )
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
        child: AppBar(
            leading: Container(),
            centerTitle: true,
            backgroundColor: globalColor.value,
            title: Text(barTitle.value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
                color: globalTextColor.value ,
              ),
            ),
          )
      ),
      key: _key,
      body: SafeArea(child: pages[0]),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: globalColor.value,
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          )
        ),
        child: NavigationBar(
          height: 60,
          selectedIndex: globalIndex.value,
          onDestinationSelected: (globalIndex) => {
              onTabTapped(globalIndex),
              if (globalIndex == 0) {
                barTitle.value = "Books (66)",
                if(pages.toString().contains('BooksSelectionPage')){
                  }else {
                    pages[0] = const BooksSelectionPage()
                  }
              } else if (globalIndex == 1) {
                barTitle.value = "Chapters",
                if(pages.toString().contains('ChapterSelectionPage')){
                  }else {
                    pages[0] = const ChapterSelectionPage()
                  }
              } else if (globalIndex == 2) {
                if(pages.toString().contains('BooksLocalPage')){
                  }else{
                    pages[0] = BooksLocalPage(bibleVersions, bookSelected, selectedChapter, 0),
                  },
                barTitle.value = bookSelected +' '+selectedChapter.toString(),
                colorIndex = 999
              } else if (globalIndex == 3) {
                barTitle.value = "Search",
                if(pages.toString().contains('SearchLocalPage')){
                  }else {
                    pages[0] = const SearchLocalPage()
                  }
              } else if (globalIndex == 4) {
                barTitle.value = "Settings",
                if(pages.toString().contains('SettingsLocalPage')){
                  }else {
                    pages[0] = const SettingsLocalPage()
                  }
              } else {
                pages[0] = BooksLocalPage(bibleVersions, bookSelected, selectedChapter,0),
              },
          },
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.menu_book_outlined),
                label: 'Books'
            ),
            NavigationDestination(
                icon: Icon(Icons.library_books_outlined),
                label: 'Chapters'
            ),
            NavigationDestination(
                icon: Icon(Icons.auto_stories_outlined),
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