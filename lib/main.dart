import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:softomatic/ChatScreen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgorundHandler);

  FirebaseFirestore.instance.collection("groups");

  runApp(const MyApp());
}

@pragma('vm:entry:point')
Future firebaseMessagingBackgorundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: ChatRoom(
        username: 'Dear Soceity',
        id: 1,
        groupName: 'firstGroup',
      ),
    );
  }
}
