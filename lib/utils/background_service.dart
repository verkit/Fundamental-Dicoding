import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:restaurant/api.dart';
import 'package:restaurant/main.dart';
import 'package:restaurant/utils/notification_helper.dart';

final ReceivePort port = ReceivePort();

class BackgroundService {
  static BackgroundService? _instance;
  static String _isolateName = 'isolate';
  static SendPort? _uiSendPort;

  BackgroundService._internal() {
    _instance = this;
  }

  factory BackgroundService() => _instance ?? BackgroundService._internal();

  void initializeIsolate() {
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      _isolateName,
    );
  }

  static Future<void> callback() async {
    print('Alarm fired!');
    final NotificationHelper _notificationHelper = NotificationHelper();
    var result = await AppRepository().getRestaurants();
    var random = 0 + Random().nextInt(19 - 0);
    await _notificationHelper.showNotification(flutterLocalNotificationsPlugin, result[random]);

    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }
}
