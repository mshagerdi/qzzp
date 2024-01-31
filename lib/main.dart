import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qzzp/api/firebase_api.dart';
// import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
// import 'package:qzzp/api/firebase_options.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import './screens/setting_screen.dart';
import './providers/earthquakes.dart';
import './screens/main_screen.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform,
      );
  // LocalNotificationService().init();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // await configureParse();
  await FirebaseApi().initNotifications();
  runApp(const MyApp());
}

// Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
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

// Future<void> configureParse() async {
//   const keyApplicationId = 'shtedLfRrrHRH095PnSbuMBTv8vAciagPz5sdpIh';
//   const keyClientKey = 'Kn71AmlkkSOASJp4gqgmPa16MiLDJKnpPePe64lN';
//   const keyParseServerUrl = 'https://parseapi.back4app.com';

//   await Parse().initialize(keyApplicationId, keyParseServerUrl,
//       clientKey: keyClientKey, debug: true);

//   final installation = await ParseInstallation.currentInstallation();
//   installation.subscribeToChannel('push');
//   await installation.save();
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        // primarySwatch: Colors.red,
        // accentColor: Colors.yellow,
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  Map<String, dynamic> payload = <String, dynamic>{};

  @override
  // void initState() {
  //   super.initState();
  //   registerNotification();
  //   checkForInitialMessage();
  // }

  // void registerNotification() async {
  //   NotificationSettings settings = await messaging.requestPermission(
  //     alert: true,
  //     announcement: false,
  //     badge: true,
  //     carPlay: false,
  //     criticalAlert: false,
  //     provisional: false,
  //     sound: true,
  //   );

  //   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //     debugPrint('User granted permission');
  //   } else if (settings.authorizationStatus ==
  //       AuthorizationStatus.provisional) {
  //     debugPrint('User granted provisional permission');
  //   } else {
  //     debugPrint('User declined or has not accepted permission');
  //     return;
  //   }

  //   await messaging.setForegroundNotificationPresentationOptions(
  //       alert: true, badge: true, sound: true);

  //   messaging.getToken().then((value) async {
  //     assert(value != null);
  //     final installation = await ParseInstallation.currentInstallation();
  //     installation.deviceToken = value;
  //     await installation.save();
  //   });

  //   messaging.onTokenRefresh.listen((value) async {
  //     final installation = await ParseInstallation.currentInstallation();
  //     installation.deviceToken = value;
  //     await installation.save();
  //   });

  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     debugPrint('Got a message whilst in the foreground!');
  //     if (message.notification != null &&
  //         message.notification?.android != null) {
  //       LocalNotificationService().showNotifications(
  //           code: message.hashCode,
  //           title: message.notification!.title!,
  //           body: message.notification!.body!,
  //           payload: jsonEncode(message.data));
  //     }
  //   });

  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //     setState(() {
  //       payload = message.data;
  //     });
  //   });

  //   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  //   LocalNotificationService().streamPayload.listen((data) {
  //     setState(() {
  //       payload = data;
  //     });
  //   });
  // }

  // void checkForInitialMessage() async {
  //   RemoteMessage? initialMessage =
  //       await FirebaseMessaging.instance.getInitialMessage();

  //   if (initialMessage != null) {
  //     handleMessage(initialMessage);
  //   }
  // }

  // void handleMessage(RemoteMessage message) {
  //   setState(() {
  //     payload = message.data;
  //   });
  // }

  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Earthquakes(),
        ),
      ],
      child: MaterialApp(
        title: 'earthquakes',
        // theme: ThemeData(
        //   primaryColor: Colors.redAccent,
        //   accentColor: Colors.yellow,
        // ),
        home: MainScreen(),
        routes: {
          MainScreen.routeName: (context) => MainScreen(),
          SettingScreen.routeName: (context) => SettingScreen(),
        },
      ),
    );
  }
}

// class LocalNotificationService {
//   //Singleton pattern
//   static final LocalNotificationService _notificationService =
//       LocalNotificationService._internal();

//   factory LocalNotificationService() {
//     return _notificationService;
//   }

//   LocalNotificationService._internal();

//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   static const channelId = '123';
//   static const channelName = 'FlutterParse';
//   static const channelDescription = 'FlutterParseNotification';
//   final StreamController<Map<String, dynamic>> controllerPayload =
//       StreamController<Map<String, dynamic>>();
//   Stream<Map<String, dynamic>> get streamPayload => controllerPayload.stream;

//   Future<void> init() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     const DarwinInitializationSettings initializationSettingsIOS =
//         DarwinInitializationSettings(
//       requestSoundPermission: false,
//       requestBadgePermission: false,
//       requestAlertPermission: false,
//     );

//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//             android: initializationSettingsAndroid,
//             iOS: initializationSettingsIOS,
//             macOS: null);

//     await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
//   }

//   final AndroidNotificationDetails _androidNotificationDetails =
//       const AndroidNotificationDetails(
//     channelId,
//     channelName,
//     channelDescription: channelDescription,
//     playSound: true,
//     priority: Priority.high,
//     importance: Importance.high,
//   );

//   Future<void> showNotifications(
//       {required int code,
//       required String title,
//       required String body,
//       String? payload}) async {
//     await flutterLocalNotificationsPlugin.show(code, title, body,
//         NotificationDetails(android: _androidNotificationDetails),
//         payload: payload);
//   }

//   void onDidReceiveNotificationResponse(
//       NotificationResponse notificationResponse) async {
//     if (notificationResponse.payload != null) {
//       final payload = jsonDecode(notificationResponse.payload!);
//       controllerPayload.sink.add(payload);
//     }
//   }

//   Future<void> cancelNotifications(int id) async {
//     await flutterLocalNotificationsPlugin.cancel(id);
//   }

//   Future<void> cancelAllNotifications() async {
//     await flutterLocalNotificationsPlugin.cancelAll();
//   }

//   void close() {
//     controllerPayload.close();
//   }
// }
