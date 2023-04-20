import 'package:flutter/material.dart';
import 'package:streaky/StreakyEnums.dart';
class StreakData
{
  StreakData(this.name, this.streakCount, this.schedule, {this.days = Days.Monday, this.dayOfMonth = 1, this.month = 1});
  String name = "";
  Schedule schedule = Schedule.Daily;
  Days days = Days.Monday; //Days defaults to monday because it may not be necessary for every type of recurrence
  int dayOfMonth = 1; //dayOfMonth defaults to 1 because it may not be necessary for every type of recurrence
  int month = 1; //month defaults to 1 because it may not be necessary for every type of recurrence
  int streakCount = 0;

  Map toJson() => {
    'name': name,
    'streakCount': streakCount,
  };
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