import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:simple_bible/page/search_page.dart';
import 'package:simple_bible/page/settings_page.dart';
import 'package:simple_bible/page/books_page.dart';
import 'package:simple_bible/page/chapter_page.dart';
import 'package:simple_bible/page/bible_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

var box = Hive.box('settingsDB');

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
var themeMode = false.obs;
var globalIndex = 2.obs;
var colorIndex = 999;
var textColorIdx = 1.obs;
var colorSliderIdx = 0.obs;
var globalFont = 'Roboto'.obs;
var globalFontIdx = 9;
var fontSize = 2.0.obs;
var chaptersScreen = [];
var bibleScreen = [];
var searchScreen = [];
var textColorDynamic = Colors.black.obs;
var brightness = ThemeData.estimateBrightnessForColor(themeColors[colorSliderIdx.value]);
var statusBarChanged = false;

var globalTextColors = const [
  Colors.white,
  Colors.black
];

var themeColors = const [
  Colors.white,
  Colors.black,
  Colors.red,
  Colors.pink,
  Colors.purple,
  Colors.deepPurpleAccent,
  Colors.indigo,
  Colors.blue,
  Colors.lightBlue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.lightGreen,
  Colors.lime,
  // Colors.yellow,
  Colors.amber,
  Colors.orange,
  Colors.deepOrange,
  Colors.brown,
  Colors.grey,
  Colors.blueGrey,
];

var themeColorShades = [
  Colors.grey.shade300,
  Colors.grey,
  Colors.red.shade100,
  Colors.pink.shade100,
  Colors.purple.shade100,
  Colors.deepPurpleAccent.shade100,
  Colors.indigo.shade100,
  Colors.blue.shade100,
  Colors.lightBlue.shade100,
  Colors.cyan.shade100,
  Colors.teal.shade100,
  Colors.green.shade100,
  Colors.lightGreen.shade100,
  Colors.lime.shade100,
  // Colors.yellow.shade100,
  Colors.amber.shade100,
  Colors.orange.shade100,
  Colors.deepOrange.shade100,
  Colors.brown.shade100,
  Colors.grey.shade100,
  Colors.blueGrey.shade100,
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("settingsDB");

  // box.clear();

  themeMode.value = box.get('themeMode',defaultValue:false);
  bibleVersions = box.get('bibleVersions',defaultValue: 'kjv');
  bookSelected = box.get('bookSelected',defaultValue: 'Genesis');
  selectedChapter = box.get('selectedChapter',defaultValue: 1);
  colorSliderIdx.value = box.get('colorSliderIdx',defaultValue: 8);
  textColorIdx.value = box.get('textColorIdx',defaultValue: 1);
  globalFont.value = box.get('globalFont',defaultValue:'Roboto');
  globalFontIdx = box.get('globalFontIdx',defaultValue: 9);
  fontSize.value = box.get('fontSize',defaultValue: 2.0);

  brightness = ThemeData.estimateBrightnessForColor(themeColors[colorSliderIdx.value]);
  textColorDynamic.value = brightness == Brightness.light ? Colors.black : Colors.white;

  pages = [BooksLocalPage(bibleVersions, bookSelected, selectedChapter, 0)];

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
        light: ThemeData(
          brightness: Brightness.light,
          primaryColor: themeColors[colorSliderIdx.value],
          fontFamily: globalFont.value,
        ),
        dark: ThemeData(
          brightness: Brightness.dark,
          primaryColor: themeColors[colorSliderIdx.value],
          fontFamily: globalFont.value,
        ),
        initial: themeMode.value ? AdaptiveThemeMode.dark : AdaptiveThemeMode.light,
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
            backgroundColor: themeColors[colorSliderIdx.value],
            title: Text(barTitle.value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
                color: textColorDynamic.value,
                // globalTextColors[textColorIdx.value] ,
              ),
            ),
          )
      ),
      key: _key,
      body: SafeArea(child: pages[0]),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: themeColorShades[colorSliderIdx.value],
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
                statusBarChanged = false,
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