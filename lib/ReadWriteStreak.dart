import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaky/StreakData.dart' as streakData;
import 'package:streaky/config.dart';
import 'StreakData.dart';
import 'dart:developer' as developer;
import 'main.dart';

import 'StreakyEnums.dart';

void WriteStreak(String key) async { //Saves data to Json
  SharedPreferences prefs = await streakData.prefs;
  List<String> streaksAsStrings = [];
  for(StreakData streak in streaks){
    streaksAsStrings.add(jsonEncode(streak));
  }
  prefs.setStringList(key, streaksAsStrings);
  number.value++;
}

void WriteSettings(String key, bool theme) async {
  SharedPreferences prefs = await streakData.prefs;
  prefs.setBool(key, theme);
}

Future<bool> ReadSettings(String key) async { //Pulls data from Json
  SharedPreferences prefs = await streakData.prefs;
  return Future<bool>.value(prefs.getBool(key)!);
}

Future ReadStreaks(String key) async {
  SharedPreferences prefs = await streakData.prefs;
  streaks.clear();
  Map<String, dynamic> json;
  for (int i = 0; i < prefs.getStringList(key)!.length; i++) {
    json = jsonDecode(prefs.getStringList(key)![i]);
    StreakData newStreak = StreakData(
        name: json["name"],
        streakCount: json["streakCount"],
        schedule: Schedule.fromJson(json["schedule"]),
        days: Days.fromJson(json["days"]),
        month: json["month"],
        dayOfMonth: json["dayOfMonth"],
        streakDone: json["streakDone"]
    );
    newStreak.lastButtonPress = DateTime.tryParse(json["lastButtonPress"])!;

    streakData.streaks.add(newStreak);
  }
}