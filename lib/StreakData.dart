import 'package:flutter/material.dart';
import 'package:streaky/StreakyEnums.dart';
class StreakData
{
  StreakData(this.name, this.streakCount, this.schedule);
  String name = "";
  Schedule schedule = Schedule.Daily;
  int streakCount = 0;
}

List<StreakData> streaks = [StreakData("brush teeth", 0, Schedule.Daily)];

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