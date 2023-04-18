import 'package:flutter/material.dart';
import 'package:streaky/StreakData.dart' as streakData;

class ThemeModeSwitch extends StatefulWidget{
  const ThemeModeSwitch(
  {Key? key}
      ) : super(key: key);

  @override
  State<ThemeModeSwitch> createState() => ThemeModeSwitchState();
}

class ThemeModeSwitchState extends State<ThemeModeSwitch>{
  @override
  Widget build(BuildContext context) {
    return Switch(
      value: streakData.lightmode,
      activeColor: Colors.deepPurpleAccent,
      onChanged: (bool value) {
        setState(() {
          streakData.lightmode = value;
        });
      },
    );
  }
}