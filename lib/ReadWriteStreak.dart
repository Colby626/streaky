import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaky/StreakData.dart';

// Future<String> get _localPath async {
//   final directory = await getApplicationDocumentsDirectory();
//
//   return directory.path;
// }
//
// Future<File> get _localFile async {
//   final path = await _localPath;
//   return File('$path/streaks.json');
// }

void WriteStreak(SharedPreferences prefs, String key) {
  List<String> streaksAsStrings = [];
  for(StreakData streak in streaks){
    streaksAsStrings.add(jsonEncode(streak));
  }
  prefs.setStringList(key, streaksAsStrings);
}

void ReadStreaks(SharedPreferences prefs, String key) {
  streaks.clear();
  for(int i = 0; i < prefs.getStringList(key)!.length; i++){
    streaks.add(jsonDecode(prefs.getStringList(key)![i]));
  }

  // final file = await _localFile;
  // String contents = await file.readAsString();
  //
  // try {
  //   final file = await _localFile;
  //
  //   // Read the file
  //    contents = await file.readAsString();
  //    StreakData streak;
  //    streak = json.decode(contents);
  //    print(streak.name);
  //   //streakData.streaks.add(json.decode(contents).map((data) => StreakData.fromJson(data)));
  //   return contents;
  //
  // } catch (e) {
  //   // If encountering an error, return 0
  //   return "bad things";
  // }
}