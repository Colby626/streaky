import 'package:flutter/material.dart';
import 'package:streaky/ReadWriteStreak.dart';
import 'package:streaky/Streak.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'notification_manager.dart';
import 'StreakButton.dart';
import 'StreakData.dart' as streakData;
import 'SettingsMenu.dart';
import 'calendar_view.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationManager().initNotification();
  Workmanager().initialize(

    // The top level function, aka callbackDispatcher
      callbackDispatcher,

      // If enabled it will post a notification whenever
      // the task is running. Handy for debugging tasks
      isInDebugMode: true
  );
  // Periodic task registration
  Workmanager().registerPeriodicTask(
    "2",

    //This is the value that will be
    // returned in the callbackDispatcher
    "simplePeriodicTask",

    // When no frequency is provided
    // the default 15 minutes is set.
    // Minimum frequency is 15 min.
    // Android will automatically change
    // your frequency to 15 min
    // if you have configured a lower frequency.
    frequency: const Duration(minutes: 1),
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

Future<void> _showNotification() async {
  var androidDetails = const AndroidNotificationDetails(
      'channelId',
      'channelName',
      importance: Importance.high);
  var generalNotificationDetails =
  const NotificationDetails();
  await flutterLocalNotificationsPlugin.show(
      0, 'Notification Title', 'Notification Body', generalNotificationDetails,
      payload: 'Notification Payload');
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {

    // initialise the plugin of flutter_local_notifications.
    FlutterLocalNotificationsPlugin flip = FlutterLocalNotificationsPlugin();

    // app_icon needs to be a added as a drawable
    // resource to the Android head project.
    var android = const AndroidInitializationSettings('@mipmap/ic_launcher');

    // initialise settings for both Android and iOS device.
    var settings = const InitializationSettings();
    flip.initialize(settings);
    _showNotificationWithDefaultSound(flip);
    return Future.value(true);
  });
}

Future _showNotificationWithDefaultSound(flip) async {

  // Show a notification after every 15 minute with the first
  // appearance happening a minute after invoking the method
  var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.high,
      priority: Priority.high
  );
  // initialise channel platform for both Android and iOS device.
  var platformChannelSpecifics = const NotificationDetails();
  await flip.show(0, 'Streaky',
      'Your are one step away to connect with Streaky',
      platformChannelSpecifics, payload: 'Default_Sound'
  );
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
                    //Navigator.pushNamed(context, '/HomePage/calendarView');
                    NotificationManager().simpleNotificationShow();
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

  Future<void> zoneSchedule () async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'scheduled title',
        'scheduled body',
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description')),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  }
}