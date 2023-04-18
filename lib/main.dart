import 'package:flutter/material.dart';
import 'package:streaky/Streak.dart';
import 'StreakButton.dart';
import 'StreakData.dart' as streakData;
import 'SettingsMenu.dart';

void main() => runApp(HomePage());

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final number = ValueNotifier(0);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Streaky",
        debugShowCheckedModeBanner: false,
        theme: ThemeData().prim,
        home: Scaffold(
          endDrawerEnableOpenDragGesture: false,
          key: _scaffoldKey,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: const Text("Streaky"),
          ),
          drawer: const SettingsMenu(),
          bottomNavigationBar: BottomAppBar(
            color: Colors.blue,
            child: Row(
              children: [
                IconButton(
                    color: Colors.white,
                    tooltip: "Calendar",
                    icon: const Icon(Icons.calendar_month),
                    onPressed: () {} //calendar goes here,
                ),
                IconButton(
                  color: Colors.white,
                  tooltip: "Settings",
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  }, //settings goes here
                )
              ],
            ),
          ),
          body: Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                  child: Column(
                    children: [
                      StreakButton("New Streak", number),
                      ValueListenableBuilder<int>(
                        valueListenable: number,
                        builder: (BuildContext context, int value,
                            Widget? child) {
                          return Column(
                            children: [
                              for (int i = 0; i <
                                  streakData.streaks.length; i++)
                                Streak(streakData.streaks[i].name, streakData
                                    .streaks[i].streakCount, Icons
                                    .access_time_filled)
                            ],
                          );
                        },
                      ),
                    ],
                  )
              )
          ),
        )
    );
  }
}