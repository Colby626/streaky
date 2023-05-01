import 'package:json_annotation/json_annotation.dart';
enum Schedule {
  Daily,
  Weekly,
  Monthly,
  Yearly;

  String toJson() => name;
  static Schedule fromJson(String json) => values.byName(json);
}

enum Days {
  Monday,
  Tuesday,
  Wednesday,
  Thursday,
  Friday,
  Saturday,
  Sunday;

  String toJson() => name;
  static Days fromJson(String json) => values.byName(json);
}