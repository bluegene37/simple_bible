import 'package:intl/intl.dart';
import '../main.dart';

int getUniqueID(){
  int uniqueID = 0;
  var now = DateTime.now();
  uniqueID = int.parse('${DateFormat('yyMMdd').format(now)}${DateFormat('HHmmssS').format(now)}');
  return uniqueID;
}

Future<List> getNotes() async {
  List vNotes = [];
  vNotes = notesBox.keys.toList();
  return vNotes;
}

Future<List> notesGroupings() async{
  final noteValues = notesBox.values.toList();
  // final groupNotes = noteValues.toSet().toList();
  return noteValues;
}

String notesJson(){
  final noteValues = notesBox.values.toList();
  var finalVerse = '';
  for( var items in noteValues){
    finalVerse += items['book'].replaceAll('[','').replaceAll(']','');
  }
  return finalVerse;
}

Future<List> filterNotes(pQuery) async{
    final noteValues = notesBox.values.toList();
    final listWhere = noteValues.where((e) => e['notes'].contains(pQuery) || e['book'].replaceAll('[','').replaceAll(']','').contains(pQuery)).toList();
    return pQuery.isNotEmpty ? listWhere : noteValues ;
}

// Future<String> getVersesNotes(vNotesJson) async{
//   var finalText = vNotesJson['book'].replaceAll('[','').replaceAll(']','').split(",");
//   var finalVerse = '';
//   var removeTexts = [];
//   await finalText.asMap().forEach((index, verse) => {
//     removeTexts = verse.split(':'),
//     finalVerse = index == 0 ? finalText[0] : '$finalVerse, ${removeTexts.last}' ,
//   });
//   return finalVerse;
// }

