import 'package:flutter/material.dart';
import 'package:streaky/config.dart';
//import 'package:streaky/ThemeModeSwitch.dart';

class SettingsMenu extends StatelessWidget{
  SettingsMenu(
  {Key? key}
      ) : super(key: key);
  final ValueNotifier<ThemeMode> _notifier = ValueNotifier(ThemeMode.light);

  @override
  Widget build(BuildContext context)
  {
    return Drawer(
      width: 200,
      child: ListView(
        children:  [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text("Settings", style: TextStyle(fontSize: 37, color: Colors.white),),
            )
          ),
          const Align(
            alignment: Alignment.center,
            child: Text("Theme Mode"),
          ),
          SwitchExample()
        ],
      ),
    );
  }
}

class SwitchExample extends StatefulWidget {
  const SwitchExample({super.key});

  @override
  State<SwitchExample> createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<SwitchExample>
{
  bool light = true;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: light,
      activeColor: Colors.deepPurpleAccent,
      onChanged: (bool value) {
        currentTheme.switchThemes();
        setState(() {
          light = value;
        });
      },
    );
  }
}