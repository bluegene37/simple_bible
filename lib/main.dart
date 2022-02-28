import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:developer';
import 'package:simple_bible/page/bible_page.dart';
import 'package:simple_bible/menu/books_title.dart';

void main() {
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
        primarySwatch: Colors.teal,
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
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: Container(),
      //   centerTitle: true,
      //   title: Text(widget.title),
      // ),
      key: _key,
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildOTHeader(context),
              buildOTBooks(context),
              buildNTHeader(context),
              buildNTBooks(context),
            ],
          ),
        ),
      ),
      body: buildPages(),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          // indicatorColor: Colors.blue.shade100,
          labelTextStyle: MaterialStateProperty.all(
            TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          )
        ),
        child: NavigationBar(
          height: 60,
          // backgroundColor: Color(0xFFf1f5fb),
          selectedIndex: _currentIndex,
          onDestinationSelected: (_currentIndex) =>
            setState(() => {
              this._currentIndex = _currentIndex,
              if(this._currentIndex == 0){
                _key.currentState!.openDrawer(),
              },
          }),
          destinations: [
            NavigationDestination(
                icon: Icon(Icons.book_outlined),
                label: 'Books'
            ),
            NavigationDestination(
                icon: Icon(Icons.menu_book_outlined),
                label: 'Chapters'
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

  Widget buildPages() {
    return BooksLocalPage();
  }

}

