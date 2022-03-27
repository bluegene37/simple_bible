import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:simple_bible/model/books.dart';
import 'package:simple_bible/main.dart';

class BooksApi {
  static Future<List<Book>> getBooksLocally(BuildContext context, jsonName, bookTitle, bookChapter) async{
    if(mainBooks.isEmpty) {
      final assetBundle = DefaultAssetBundle.of(context);
      mainBooks = await assetBundle.loadString('assets/'+bibleVersions+'.json');
    }
    final body = json.decode(mainBooks);
    final bookList = body.map<Book>(Book.fromJson).toList();
    final resultText = bookList.where((val) => val.book == bookTitle && val.chapter == bookChapter).toList();
    final chapters = bookList.where((x) => x.book == bookTitle).toList();
    final unique = <String>{};
    final uniqueList = chapters.where((x) => unique.add(x.chapter.toString())).toList();
    lastChapter = uniqueList.length;

    return resultText;
  }
}

class BooksTitleApi {
  static Future<List<BookTitle>> getBooksLocally(BuildContext context) async{
    if(mainBooksMenu == '') {
      final assetBundle = DefaultAssetBundle.of(context);
      mainBooksMenu = await assetBundle.loadString('assets/booktitle.json');
    }
    final body = json.decode(mainBooksMenu);
    final bookNames = body.map<BookTitle>(BookTitle.fromJson).toList();

    return bookNames;
  }
}

class BooksChapterApi {
  static Future<List<Book>> getBooksLocally(BuildContext context, jsonName,bookTitle) async{
    if(mainBooks.isEmpty) {
      final assetBundle = DefaultAssetBundle.of(context);
      mainBooks = await assetBundle.loadString('assets/'+bibleVersions+'.json');
    }
    final body = json.decode(mainBooks);
    final allChapter = body.map<Book>((json) => Book.fromJson(json)).toList();
    final bookChapter = allChapter.where((x) => x.book == bookTitle).toList();
    final unique = <String>{};
    final uniqueList = bookChapter.where((x) => unique.add(x.chapter.toString())).toList();

    return uniqueList;
  }
}

class SearchApi {
  static Future<List<Book>> getBooksLocally(BuildContext context, jsonName, searchQuery) async{
    if(mainBooks.isEmpty) {
      final assetBundle = DefaultAssetBundle.of(context);
      mainBooks = await assetBundle.loadString('assets/'+bibleVersions+'.json');
    }
    final body = json.decode(mainBooks);
    final bookList = body.map<Book>(Book.fromJson).toList();
    final resultText = bookList.where((val) =>
        val.text.toLowerCase().contains(searchQuery.toLowerCase()) == true
        // || val.book.toLowerCase().contains(searchQuery.toLowerCase()) == true && val.chapter == 1 && val.verse == 1
    ).toList();
    return resultText;
  }
}