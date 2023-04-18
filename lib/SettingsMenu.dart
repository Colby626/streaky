import 'package:flutter/material.dart';
import 'package:streaky/ThemeModeSwitch.dart';

class SettingsMenu extends StatelessWidget{
  const SettingsMenu(
  {Key? key}
      ) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return Drawer(
      width: 200,
      child: ListView(
        children: const [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text("Settings", style: TextStyle(fontSize: 37, color: Colors.white),),
            )
          ),
          Align(
            alignment: Alignment.center,
            child: Text("Theme Mode"),
          ),
          ThemeModeSwitch(),
        ],
      ),
    );
  }
}