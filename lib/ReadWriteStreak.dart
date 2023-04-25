import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:streaky/Streak.dart';
import 'package:streaky/StreakData.dart';
import 'StreakData.dart' as streakData;

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/streaks.json');
}

Future<File> WriteStreak(List<StreakData> streaks) async {
  final file = await _localFile;

  // Write the file
  print(file.writeAsString(jsonEncode(streaks)));
  return file.writeAsString(jsonEncode(streaks));
}

Future<String> ReadStreaks() async {
  final file = await _localFile;
  String contents = await file.readAsString();

  try {
    final file = await _localFile;

    // Read the file
     contents = await file.readAsString();
     StreakData streak;
     streak = json.decode(contents);
     print(streak.name);
    //streakData.streaks.add(json.decode(contents).map((data) => StreakData.fromJson(data)));
    return contents;

  } catch (e) {
    // If encountering an error, return 0
    return "bad things";
  }
}