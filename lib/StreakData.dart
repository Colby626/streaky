import 'package:streaky/StreakyEnums.dart';
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

  Map<String, dynamic> toJson() => {
    'name': name.toString(),
    'streakCount': streakCount.toString(),
    'schedule': schedule.toString(),
    'days': days.toString(),
    'dayOfMonth': dayOfMonth.toString(),
    'month': month.toString()
  };

  factory StreakData.fromJson(Map<String, dynamic> json) {
    return StreakData(
      name: json['name'] ?? "",
      streakCount: int.parse(json['streakCount']) ?? 0,
      schedule: json['schedule'],
      days: json['days'],
      dayOfMonth: int.parse(json['dayOfMonth']) ?? 1,
      month: int.parse(json['month']) ?? 1
    );
  }
}

List<StreakData> streaks = [];