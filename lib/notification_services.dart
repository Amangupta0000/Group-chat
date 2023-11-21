import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  void requestNotificationPermission() async {
    NotificationSettings setting = await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true);
    if (setting.authorizationStatus == AuthorizationStatus.authorized) {
      print('user granted permission');
    } else if (setting.authorizationStatus == AuthorizationStatus.provisional) {
      print('user granted provisional');
    } else {
      print('user denied');
    }
  }

  void initInfo(BuildContext context) async {
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettings =
        InitializationSettings(android: androidInitialize);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) {},
    );
  }

  void firebaseInit() {
    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        print(message.notification!.body.toString());
      }
      showNotification(message);
    });
  }

  Future showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        Random.secure().nextInt(100000).toString(),
        'High importance Notification',
        importance: Importance.max);
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(channel.id.toString(), channel.name,
            channelDescription: 'your channel description',
            importance: Importance.high,
            priority: Priority.high,
            ticker: 'ticker');
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    Future.delayed(Duration.zero, () {
      flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails);
    });
  }

  Future<String> getToken() async {
    String? token = await messaging.getToken();
    print(token);
    return token!;
  }

  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
    });
  }
}
