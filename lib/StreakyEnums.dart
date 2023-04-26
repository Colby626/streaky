import 'package:json_annotation/json_annotation.dart';
enum Schedule {
  @JsonValue("Schedule.Daily")
  Daily,
  @JsonValue("Schedule.Weekly")
  Weekly,
  @JsonValue("Schedule.BiWeekly")
  BiWeekly,
  @JsonValue("Schedule.Monthly")
  Monthly,
  @JsonValue("Schedule.Yearly")
  Yearly,
  @JsonValue("Schedule.MWF")
  MWF,
  @JsonValue("Schedule.TR")
  TR,
}

enum Days {
  @JsonValue("Days.Monday")
  Monday,
  @JsonValue("Days.Tuesday")
  Tuesday,
  @JsonValue("Days.Wednesday")
  Wednesday,
  @JsonValue("Days.Thursday")
  Thursday,
  @JsonValue("Days.Friday")
  Friday,
  @JsonValue("Days.Saturday")
  Saturday,
  @JsonValue("Days.Sunday")
  Sunday,
}