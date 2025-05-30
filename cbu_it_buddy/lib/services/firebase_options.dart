// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyDv-ekD7OgRietiO2GOOeVGcDistnPOvuA',
    appId: '1:871680129456:web:2c6be689ebf1ed05803e75',
    messagingSenderId: '871680129456',
    projectId: 'cbu-it-buddy',
    authDomain: 'cbu-it-buddy.firebaseapp.com',
    storageBucket: 'cbu-it-buddy.appspot.com',
    measurementId: 'G-73Z8V5JL7X',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA9Y7KwhlJklGrVXMfGDmZJBfcPec5TS8E',
    appId: '1:871680129456:android:fe36364f77412c23803e75',
    messagingSenderId: '871680129456',
    projectId: 'cbu-it-buddy',
    storageBucket: 'cbu-it-buddy.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBfluBI4cpX7fN1Eh_aIpcjioXs2lcU8jg',
    appId: '1:871680129456:ios:a4848bbec472a2a1803e75',
    messagingSenderId: '871680129456',
    projectId: 'cbu-it-buddy',
    storageBucket: 'cbu-it-buddy.appspot.com',
    iosBundleId: 'com.example.cbuItBuddy',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBfluBI4cpX7fN1Eh_aIpcjioXs2lcU8jg',
    appId: '1:871680129456:ios:a4848bbec472a2a1803e75',
    messagingSenderId: '871680129456',
    projectId: 'cbu-it-buddy',
    storageBucket: 'cbu-it-buddy.appspot.com',
    iosBundleId: 'com.example.cbuItBuddy',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDv-ekD7OgRietiO2GOOeVGcDistnPOvuA',
    appId: '1:871680129456:web:890154e1deee42df803e75',
    messagingSenderId: '871680129456',
    projectId: 'cbu-it-buddy',
    authDomain: 'cbu-it-buddy.firebaseapp.com',
    storageBucket: 'cbu-it-buddy.appspot.com',
    measurementId: 'G-PNJ4ZVQ6XV',
  );
}
