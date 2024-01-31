// import 'dart:convert';

// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'firebase_options.dart';
// import 'local_notification_service.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Title: ${message.notification?.body}');
  print('Title: ${message.data}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await _firebaseMessaging.requestPermission();
    try {
      final fCMToken = await _firebaseMessaging.getToken();
      print('Token: $fCMToken');
      FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
      await prefs.setString('fCMToken', fCMToken!);
    } catch (error) {
      print('No Token');
    }
  }

  // Future firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //   debugPrint("Handling a background message");
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );

  //   if (message.notification != null) {
  //     LocalNotificationService().showNotifications(
  //         code: message.hashCode,
  //         title: message.notification!.title!,
  //         body: message.notification!.body!,
  //         payload: jsonEncode(message.data));
  //   }
  // }
}
