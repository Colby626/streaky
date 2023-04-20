import 'package:flutter/material.dart';
import 'package:streaky/ReadWriteStreak.dart';
import 'package:streaky/Streak.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'StreakButton.dart';
import 'StreakData.dart' as streakData;
import 'SettingsMenu.dart';
import 'calendar_view.dart';

void main() {
  runApp(MaterialApp(
  title: "Streaky Router",
  initialRoute: '/',
  routes: {
  '/': (context) => StartPage(),
  '/HomePage': (context) => HomePage(),
  '/HomePage/calendarView': (context) => const CalendarView(),
  },
  ));
}

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}
class _StartPageState extends State<StartPage> {
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Streaky'),
    ),
    body: Center(
      child: ElevatedButton(
        child: const Text('Enable Notifications'),
        onPressed: () {
          _showPermissionDialog();
        },
      ),
    ),
  );
}
  Future<void> requestNotificationPermissions() async {
    final status = await Permission.notification.request();
    if (status.isDenied) {
      _showPermissionDialog();
    } else if (status.isPermanentlyDenied) {
      _showSettingsDialog();
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Enable Notifications'),
        content: const Text('This app needs permission to send notifications.'),
        actions: [
          TextButton(
            child: const Text('CANCEL'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('OK'),
            onPressed: () async {
              Navigator.pushNamed(context, '/HomePage');
              final status = await Permission.notification.request();
              if (status.isPermanentlyDenied) {
                _showSettingsDialog();
              }
            },
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Notification Permissions'),
        content: const Text('Please enable notification permissions in the device settings.'),
        actions: [
          TextButton(
            child: const Text('CANCEL'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('SETTINGS'),
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final number = ValueNotifier(0);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String streak = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Streaky",
        debugShowCheckedModeBanner: false,
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
                  onPressed: () {
                    Navigator.pushNamed(context, '/HomePage/calendarView');
                  },
                ),
                IconButton(
                  color: Colors.white,
                  tooltip: "Settings",
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                ),
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
                              FutureBuilder(
                                future: ReadStreak(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<String> snap) {
                                  return Text('${snap.data}');
                                },
                              ),
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