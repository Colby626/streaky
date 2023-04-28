import 'package:flutter/material.dart';
import 'dart:async';
import 'package:streaky/ReadWriteStreak.dart';
import 'package:streaky/Streak.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'notification_manager.dart';
import 'StreakButton.dart';
import 'StreakData.dart' as streakData;
import 'SettingsMenu.dart';
import 'calendar_view.dart';
import 'config.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationManager().initNotification();
  Workmanager().initialize(
      callbackDispatcher,
  );

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

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    // initialise the plugin of flutter_local_notifications.
    FlutterLocalNotificationsPlugin flip = FlutterLocalNotificationsPlugin();

    // app_icon needs to be a added as a drawable
    // resource to the Android head project.
    var android = const AndroidInitializationSettings('@mipmap/streaky_logo');

    // initialise settings for both Android and iOS device.
    var settings = const InitializationSettings();
    flip.initialize(settings);

    for (int i = 0; i < streakData.streaks.length; i++)
      {
        if (taskName == streakData.streaks[i].name)
          {
            NotificationManager().simpleNotificationShow(taskName);
            streakData.streaks[i].streakDone = false;
            break;
          }
      }
    return Future.value(true);
  });
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

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();

  final number = ValueNotifier(0);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
}

class HomePageState extends State<HomePage> {

  @override
  void initState() {
    currentTheme.addListener((){
      setState(() {

      });
    });
    super.initState();
    FetchStreaks();
  }

  Future FetchStreaks() async {
    setState(() {
      ReadStreaks();
      widget.number.value++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Streaky",
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: currentTheme.currentTheme(),
        home: Scaffold(
          endDrawerEnableOpenDragGesture: false,
          key: widget._scaffoldKey,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: const Text("Streaky"),
          ),
          drawer: SettingsMenu(),
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
                    widget._scaffoldKey.currentState?.openDrawer();
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
                      StreakButton("New Streak", widget.number),
                      ValueListenableBuilder<int>(
                        valueListenable: widget.number,
                        builder: (BuildContext context, int value,
                            Widget? child) {
                          return Column(
                            children: [
                              FutureBuilder(
                                future: ReadStreaks(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<String> snap) {
                                  if (snap.hasData) {
                                    return Text('${snap.data}');
                                  }
                                  else {
                                    return const Text("no");
                                  }
                                },
                              ),
                              for (int i = 0; i < streakData.streaks.length; i++)
                                Streak(streakData.streaks[i].name, streakData
                                    .streaks[i].streakCount, Icons
                                    .access_time_filled, streakData.streaks[i].schedule.name),
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