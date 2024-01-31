// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey:
        'BH0tHNrjie7HWrM4YoWRVOvbz4ICLwNVSkoMhEykhoyMAlBX6J3UieLXhV4SogRuyuUmkRH11DyJrHZd2KMxtps',
    appId: '1:1083104768954:android:7e7d8f4a7a583c6c402383',
    messagingSenderId: '1083104768954',
    projectId: 'qzzp-app',
    storageBucket: 'flutter-parse-notification.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey:
        'BH0tHNrjie7HWrM4YoWRVOvbz4ICLwNVSkoMhEykhoyMAlBX6J3UieLXhV4SogRuyuUmkRH11DyJrHZd2KMxtps',
    appId: '1:1083104768954:android:7e7d8f4a7a583c6c402383',
    messagingSenderId: '1083104768954',
    projectId: 'qzzp-app',
    storageBucket: 'flutter-parse-notification.appspot.com',
    iosClientId:
        '77192768317-nsn56q9lhmc4g8s50hioiarkb40sm2s6.apps.googleusercontent.com',
    iosBundleId: 'com.back4app.flutterParseNotification',
  );
}