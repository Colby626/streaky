import 'dart:convert';
import 'package:streaky/StreakyEnums.dart';
import 'package:json_annotation/json_annotation.dart';
part 'StreakData.g.dart';

@JsonSerializable()
class StreakData
{
  StreakData({required this.name, required this.streakCount, required this.schedule, this.days = Days.Monday, this.dayOfMonth = 1, this.month = 1, this.streakDone = false}); //{required this.streakCount}, {required this.schedule}, {this.days = Days.Monday, this.dayOfMonth = 1, this.month = 1});
  String name = "";
  Schedule schedule = Schedule.Daily;
  Days days = Days.Monday; //Days defaults to monday because it may not be necessary for every type of recurrence
  int dayOfMonth = 1; //dayOfMonth defaults to 1 because it may not be necessary for every type of recurrence
  int month = 1; //month defaults to 1 because it may not be necessary for every type of recurrence
  int streakCount = 0;
  bool streakDone = false;

  Map<String, dynamic> toJson() => _$StreakDataToJson(this);

  factory StreakData.fromJson(Map<String, dynamic> json) => _$StreakDataFromJson(json);
}

List<StreakData> streaks = [];