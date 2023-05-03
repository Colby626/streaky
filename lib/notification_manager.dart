import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationManager {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
    const AndroidInitializationSettings('streaky_logo');

    DarwinInitializationSettings initializationIos =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) {},
    );
    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationIos);
    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {},
    );
  }

  Future<void> simpleNotificationShow(String name) async { //This is the only one that we are using
    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(name, name,
        priority: Priority.high,
        importance: Importance.max,
        icon: 'streaky_logo',
        channelShowBadge: true,
        largeIcon: const DrawableResourceAndroidBitmap('streaky_logo'));

    NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await notificationsPlugin.show(
        0, 'Streak Notification', 'You need to do your $name streak!', notificationDetails);
  }

  Future<void> bigPictureNotificationShow() async {
    BigPictureStyleInformation bigPictureStyleInformation =
    const BigPictureStyleInformation(
        DrawableResourceAndroidBitmap('streaky_logo'),
        contentTitle: 'Streaky Streaks',
        largeIcon: DrawableResourceAndroidBitmap('streaky_logo'));

    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('big_picture_id', 'Streaky Streaks',
        priority: Priority.high,
        importance: Importance.max,
        styleInformation: bigPictureStyleInformation);

    NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await notificationsPlugin.show(
        1, 'Big Streak Notification', 'Streaky Streaks', notificationDetails);
  }

  Future<void> multipleNotificationShow() async {
    AndroidNotificationDetails androidNotificationDetails =
    const AndroidNotificationDetails('Channel_id', 'Streaky Streaks',
        priority: Priority.high,
        importance: Importance.max,
        groupKey: 'Streaky Streaks');

    NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    notificationsPlugin.show(
        0, 'Streak Notification', 'You have a streak to complete', notificationDetails);

    Future.delayed(
      const Duration(milliseconds: 1000),
          () {
        notificationsPlugin.show(
            1, 'Streak Notification', 'You have a streak to complete', notificationDetails);
      },
    );

    Future.delayed(
      const Duration(milliseconds: 1500),
          () {
        notificationsPlugin.show(
            2, 'Streak Notification', 'You have a streak to complete', notificationDetails);
      },
    );

    List<String> lines = ['user1', 'user2', 'user3'];

    InboxStyleInformation inboxStyleInformation =
    InboxStyleInformation(lines, contentTitle: '${lines.length} messages',summaryText: 'Streaky Streaks');

    AndroidNotificationDetails androidNotificationSpesific=AndroidNotificationDetails(
        'groupChannelId',
        'Streaky Streaks',
        styleInformation: inboxStyleInformation,
        groupKey: 'commonMessage',
        setAsGroupSummary: true
    );
    NotificationDetails platformChannelSpe=NotificationDetails(android: androidNotificationSpesific);
    await notificationsPlugin.show(3, 'Attention', '${lines.length} messages', platformChannelSpe);
  }
}