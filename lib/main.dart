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
    await ReadStreaks("streaks");
    for (int i = 0; i < streakData.streaks.length; i++) //Finds the streak from the list of streaks that has the unique name the same as the workmanager task
      {
        if (taskName == streakData.streaks[i].name)
          {
            if (!streakData.streaks[i].streakDone) //They lost their streak
              {
                streakData.streaks[i].streakCount = 0;
              }
            NotificationManager().simpleNotificationShow(taskName);
            streakData.streaks[i].streakDone = false;
            WriteStreak("streaks");
            await ReadStreaks("streaks");
            number.value++; //Updates the value on the streaks
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
bool isGranted = false;
@override
void initState() {
  super.initState();
  CheckPerms();
}

void CheckPerms() async { //Checks if permission to send notifications is enabled for the app and if it is goes to the homepage, otherwise goes to the start screen which asks for permission
  final status = await Permission.notification.request();
  if (status.isGranted){
    Navigator.pushNamed(context, '/HomePage');
  }
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Streaky'),
    ),
    body: Center(
        child: AlertDialog(
          insetPadding: const EdgeInsets.all(20),
          title: const Text("Enable Notifications"),
          content: const Text(
              'This app needs permission to send notifications.'),
          actions: [
            TextButton(
              child: const Text('Disable'),
              onPressed: () => Navigator.pop(context),
            ),

            TextButton(
                onPressed: () async {
                  Navigator.pushNamed(context, '/HomePage');
                  final status = await Permission.notification.request();
                  if (status.isPermanentlyDenied) {
                    _showSettingsDialog();
                  }
                },
                child: const Text("Enable")
            ),
          ],
        ) //ElevatedButton(
      //   child: const Text('Enable Notifications'),
      //   onPressed: () {
      //     _showPermissionDialog();
      //   },
      // ),
    ),
  );
}
  Future<void> requestNotificationPermissions() async {
    final status = await Permission.notification.request();
    isGranted = status == PermissionStatus.granted;
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
            child: const Text('Disable'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Enable'),
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

final number = ValueNotifier(0);

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
}

class HomePageState extends State<HomePage> {

  bool theme = true;

  @override
  void initState() {
    currentTheme.addListener((){
      setState(() {
      });
    });
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      FetchStreaks();
      FetchSettings();
    });
  }

  void FetchSettings() async {
    theme = await ReadSettings("theme");
    setState(() {
      currentTheme.changeTheme(theme);
    });
  }

  void FetchStreaks() async {
    setState(() {
      ReadStreaks("streaks");
      number.value++;
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
                      StreakButton("New Streak", number),
                      ValueListenableBuilder<int>(
                        valueListenable: number,
                        builder: (BuildContext context, int value,
                            Widget? child) {
                          return Column(
                            children: [
                              for (int i = 0; i < streakData.streaks.length; i++)
                                Streak(streakData.streaks[i].name, Icons
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