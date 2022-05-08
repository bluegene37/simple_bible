// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settingsdb.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsAdapter extends TypeAdapter<Settings> {
  @override
  final int typeId = 0;

  @override
  Settings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Settings()
      ..bibleVersions = fields[0] as String
      ..bookSelected = fields[1] as String
      ..selectedChapter = fields[2] as int
      ..searchQueryMain = fields[3] as String
      ..textColorIdx = fields[4] as int
      ..colorSliderIdx = fields[5] as int
      ..globalFont = fields[7] as String
      ..globalFontIdx = fields[8] as int
      ..fontSize = fields[9] as double;
  }

  @override
  void write(BinaryWriter writer, Settings obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.bibleVersions)
      ..writeByte(1)
      ..write(obj.bookSelected)
      ..writeByte(2)
      ..write(obj.selectedChapter)
      ..writeByte(3)
      ..write(obj.searchQueryMain)
      ..writeByte(4)
      ..write(obj.textColorIdx)
      ..writeByte(5)
      ..write(obj.colorSliderIdx)
      ..writeByte(7)
      ..write(obj.globalFont)
      ..writeByte(8)
      ..write(obj.globalFontIdx)
      ..writeByte(9)
      ..write(obj.fontSize);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HighLightsAdapter extends TypeAdapter<HighLights> {
  @override
  final int typeId = 1;

  @override
  HighLights read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HighLights()
      ..hlBook = fields[0] as String
      ..hlChapter = fields[1] as int
      ..hlVerse = fields[2] as int
      ..hlValue = fields[3] as int;
  }

  @override
  void write(BinaryWriter writer, HighLights obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.hlBook)
      ..writeByte(1)
      ..write(obj.hlChapter)
      ..writeByte(2)
      ..write(obj.hlVerse)
      ..writeByte(3)
      ..write(obj.hlValue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HighLightsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
