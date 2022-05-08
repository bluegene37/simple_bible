import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'settingsdb.g.dart';

@HiveType(typeId: 0)

class Settings extends HiveObject {
  @HiveField(0)
  late String bibleVersions;
  @HiveField(1)
  late String bookSelected;
  @HiveField(2)
  late int selectedChapter;
  @HiveField(3)
  late String searchQueryMain;
  @HiveField(4)
  late int textColorIdx;
  @HiveField(5)
  late int colorSliderIdx;
  @HiveField(7)
  late String globalFont;
  @HiveField(8)
  late int globalFontIdx;
  @HiveField(9)
  late double fontSize;

}

@HiveType(typeId: 1)

class HighLights extends HiveObject {
  @HiveField(0)
  late String hlBook;
  @HiveField(1)
  late int hlChapter;
  @HiveField(2)
  late int hlVerse;
  @HiveField(3)
  late int hlValue;
}

// flutter packages pub run build_runner build