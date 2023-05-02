// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'StreakData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StreakData _$StreakDataFromJson(Map<String, dynamic> json) => StreakData(
      name: json['name'] as String,
      streakCount: json['streakCount'] as int,
      schedule: $enumDecode(_$ScheduleEnumMap, json['schedule']),
      days: $enumDecodeNullable(_$DaysEnumMap, json['days']) ?? Days.Monday,
      dayOfMonth: json['dayOfMonth'] as int? ?? 1,
      month: json['month'] as int? ?? 1,
    )
      ..streakDone = json['streakDone'] as bool
      ..lastButtonPress = DateTime.parse(json['lastButtonPress'] as String);

Map<String, dynamic> _$StreakDataToJson(StreakData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'schedule': instance.schedule,
      'days': instance.days,
      'dayOfMonth': instance.dayOfMonth,
      'month': instance.month,
      'streakCount': instance.streakCount,
      'streakDone': instance.streakDone,
      'lastButtonPress': instance.lastButtonPress.toIso8601String(),
    };

const _$ScheduleEnumMap = {
  Schedule.Daily: 'Daily',
  Schedule.Weekly: 'Weekly',
  Schedule.Monthly: 'Monthly',
  Schedule.Yearly: 'Yearly',
};

const _$DaysEnumMap = {
  Days.Monday: 'Monday',
  Days.Tuesday: 'Tuesday',
  Days.Wednesday: 'Wednesday',
  Days.Thursday: 'Thursday',
  Days.Friday: 'Friday',
  Days.Saturday: 'Saturday',
  Days.Sunday: 'Sunday',
};
