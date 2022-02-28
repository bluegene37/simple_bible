// import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class Book {
  final String translation;
  final String id;
  final String book;
  final String chapter;
  final String verse;
  final String text;

  const Book({
    required this.translation,
    required this.id,
    required this.book,
    required this.chapter,
    required this.verse,
    required this.text,
  });

  static Book fromJson(json) => Book(
    translation: json['translation_id'],
    id: json['book_id'],
    book: json['book_name'],
    chapter: json['chapter'],
    verse: json['verse'],
    text: json['text'],
  );

}
