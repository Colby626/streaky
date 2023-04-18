import 'package:flutter/material.dart';
class StreakData
{
  StreakData(this.name, this.streakCount);
  String name = "";
  int streakCount = 0;
}

List<StreakData> streaks = [];

bool lightmode = false;

ThemeData ThemeSelect()
{
    if (!lightmode)
    {
      return ThemeData.dark();
    }
    else{
      return ThemeData.light();
    }
}