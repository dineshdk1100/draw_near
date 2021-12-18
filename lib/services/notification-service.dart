import 'package:draw_near/services/user-service.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService instance = NotificationService._internal();

  FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('logo_transparent');
  final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings();

  late NotificationDetails notificationDetails;

  NotificationService._internal() {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('112022', 'Daily Reminder',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
            timeoutAfter: 86400000);
    const IOSNotificationDetails iosNotificationDetails =
        IOSNotificationDetails();

    notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);
    //initialize();
  }

  initialize() async {
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    return await notificationsPlugin.initialize(initializationSettings);
  }

  showNotification()async{
    var res = await initialize();
    print(res.toString());
    notificationsPlugin.show(22, 'notification_title'.tr(), 'notification_body'.tr(), notificationDetails);
  }

  scheduleNotification() async{
    TimeOfDay timeOfDay = UserService.instance.reminderTime;
    var res = await initialize();
    print(res.toString());
    var scheduledDate = await _nextInstanceOfGivenTime(timeOfDay);
    print(scheduledDate.toIso8601String());
    notificationsPlugin.zonedSchedule(
        23,
        'notification_title'.tr(),
        'notification_body'.tr(),
        scheduledDate,
        notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.wallClockTime,
        androidAllowWhileIdle: true,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  Future<tz.TZDateTime> _nextInstanceOfGivenTime(TimeOfDay timeOfDay) async{
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(await FlutterNativeTimezone.getLocalTimezone()));
    print(await FlutterNativeTimezone.getLocalTimezone());
    final tz.TZDateTime now =
        tz.TZDateTime.now(tz.getLocation(await FlutterNativeTimezone.getLocalTimezone()));
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month,
        now.day, timeOfDay.hour, timeOfDay.minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    print(scheduledDate.toIso8601String());
    return scheduledDate;
  }

  Future<void> cancelNotification() async {
    return notificationsPlugin.cancel(22);
  }
}
