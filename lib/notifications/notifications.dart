import 'dart:convert';
import 'dart:math';
import 'package:karostreammemories/drive/http/app-http-client.dart';
import 'package:karostreammemories/drive/screens/file-list/shared-screen.dart';
import 'package:karostreammemories/drive/screens/file-preview/file-preview-screen.dart';
import 'package:karostreammemories/drive/state/drive-state.dart';
import 'package:karostreammemories/drive/state/file-pages.dart';
import 'package:karostreammemories/drive/state/root-navigator-key.dart';
import 'package:karostreammemories/notifications/notification-id.dart';
import 'package:karostreammemories/notifications/payloads/file-shared-notif-payload.dart';
import 'package:karostreammemories/notifications/payloads/notification-payload.dart';
import 'package:karostreammemories/transfers/transfers-screen/transfers-screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

class Notifications {
  Notifications(this.http) {
    _initFirebaseMessaging(this);
    _initLocalNotifications(local, _onSelectNotification);
  }
  final AppHttpClient? http;
  final local = FlutterLocalNotificationsPlugin();
  final fcm = FirebaseMessaging.instance;

  notify(String? title, {String? body, String? payload, int? localId, int? progress}) {
    final platformChannelSpecifics = NotificationDetails(
      android: _androidNotifDetails(progress),
      iOS: IOSNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: false,
      ),
    );
    if (localId == null) {
      localId = new Random().nextInt(10000);
    }
    local.show(localId, title, body, platformChannelSpecifics, payload: payload);
  }

  cancel(int notifId) {
    local.cancel(notifId);
  }
}

Future<dynamic> _onSelectNotification(String? encodedPayload) async {
  NotificationPayload payload = NotificationPayload.fromRawJson(encodedPayload!);
  final state = rootNavigatorKey.currentContext!.read<DriveState>();

  if (payload.notifId == NotificationType.transferProgress) {
    TransfersScreen.open();
  } else if (payload.notifId == NotificationType.fileShared) {
    final fileNotifPayload = FileSharedNotifPayload.fromRawJson(encodedPayload);
    if (state.activePage is! SharesPage) {
      rootNavigatorKey.currentState!.pushNamed(SharedScreen.ROUTE);
    }
    if ( ! fileNotifPayload.multiple) {
      final entry = state.entryCache.get(fileNotifPayload.entryId);
      if (entry != null) {
        FilePreviewScreen.open(state.entryCache.get(fileNotifPayload.entryId));
      }
    }
  }
}

_initFirebaseMessaging(Notifications notifs) async {
  await notifs.fcm.requestPermission(sound: false);
  FirebaseMessaging.onMessage.listen((e) {
    notifs.notify(e.notification!.title, body: e.notification!.body, payload: json.encode(e.data));
  });
  FirebaseMessaging.onMessageOpenedApp.listen((e) {
    _onSelectNotification(json.encode(e.data));
  });
}

Future<bool?> _initLocalNotifications(FlutterLocalNotificationsPlugin local, SelectNotificationCallback callback) {
  const initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  final initializationSettingsIOS =  IOSInitializationSettings(
    defaultPresentAlert: false,
    defaultPresentBadge: true,
    defaultPresentSound: false,
  );
  final initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  return local.initialize(
    initializationSettings,
    onSelectNotification: callback
  );
}

AndroidNotificationDetails _androidNotifDetails(int? progress) {
  return AndroidNotificationDetails(
    'default', 'Default channel for the app.',
    importance: Importance.defaultImportance,
    priority: Priority.defaultPriority,
    showWhen: true,
    category: 'social',
    playSound: false,
    fullScreenIntent: false,
    enableVibration: false,
    showProgress: progress != null,
    maxProgress: 100,
    progress: progress ?? 0,
  );
}