
class Book {
  final String id;
  final String book;
  final int chapter;
  final int verse;
  final String text;

  const Book({
    required this.id,
    required this.book,
    required this.chapter,
    required this.verse,
    required this.text,
  });

  static Book fromJson(json) => Book(
    id: json['book_id'],
    book: json['book_name'],
    chapter: json['chapter'],
    verse: json['verse'],
    text: json['text'],
  );

}


class BookTitle {
  final String key;
  final String val;

  const BookTitle({
    required this.key,
    required this.val,
  });

  static BookTitle fromJson(json) => BookTitle(
      key: json['key'],
      val: json['val']
  );

}

