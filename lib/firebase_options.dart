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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBNDGrWymEonY2FCDBFjBlwUYvdFLm-Yh0',
    appId: '1:156316514718:web:ba53a993142fe212a4fe8f',
    messagingSenderId: '156316514718',
    projectId: 'bukka-63948',
    authDomain: 'bukka-63948.firebaseapp.com',
    storageBucket: 'bukka-63948.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDrKokD0oNY6bxPJWqcEZQTe2MCS1m9on0',
    appId: '1:156316514718:android:10daa0b9792f9b71a4fe8f',
    messagingSenderId: '156316514718',
    projectId: 'bukka-63948',
    storageBucket: 'bukka-63948.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDrjVDxNTXVI5dtmiSXcnWONgWAakPXzCk',
    appId: '1:156316514718:ios:24300d01e5ad6ecea4fe8f',
    messagingSenderId: '156316514718',
    projectId: 'bukka-63948',
    storageBucket: 'bukka-63948.appspot.com',
    iosClientId: '156316514718-3f21kn8vu1vlcdch9apccokoetvngfg1.apps.googleusercontent.com',
    iosBundleId: 'com.example.bukka',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDrjVDxNTXVI5dtmiSXcnWONgWAakPXzCk',
    appId: '1:156316514718:ios:24300d01e5ad6ecea4fe8f',
    messagingSenderId: '156316514718',
    projectId: 'bukka-63948',
    storageBucket: 'bukka-63948.appspot.com',
    iosClientId: '156316514718-3f21kn8vu1vlcdch9apccokoetvngfg1.apps.googleusercontent.com',
    iosBundleId: 'com.example.bukka',
  );
}
