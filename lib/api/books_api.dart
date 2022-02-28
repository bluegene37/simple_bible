import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:simple_bible/model/books.dart';

class BooksApi {
  static Future<List<Book>> getBooksLocally(BuildContext context) async{
    final assetBundle = DefaultAssetBundle.of(context);
    // final data = await assetBundle.loadString('assets/books.json');
    final data = await assetBundle.loadString('assets/smallBook.json');
    final body = json.decode(data);
    log(body.toString());
    return body.map<Book>(Book.fromJson).toList();
  }
}
