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
    apiKey: 'AIzaSyA0crQcQigUu_RpGkU4-0yCHi_z_JC_yRk',
    appId: '1:986544922490:web:fd2d0c94c01f8a619380c3',
    messagingSenderId: '986544922490',
    projectId: 'collectioan',
    authDomain: 'collectioan.firebaseapp.com',
    storageBucket: 'collectioan.firebasestorage.app',
    measurementId: 'G-SP4J42G2E4',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA47Z_6Y8l1wfmHsNSiviBWUGgFzUAsH9A',
    appId: '1:986544922490:android:29f5da5c1c50efe59380c3',
    messagingSenderId: '986544922490',
    projectId: 'collectioan',
    storageBucket: 'collectioan.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBuHtschFGtSRUM714wEASGFzuZe0QRCNI',
    appId: '1:986544922490:ios:a854e527c108bd1c9380c3',
    messagingSenderId: '986544922490',
    projectId: 'collectioan',
    storageBucket: 'collectioan.firebasestorage.app',
    iosBundleId: 'com.example.collectioan',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBuHtschFGtSRUM714wEASGFzuZe0QRCNI',
    appId: '1:986544922490:ios:a854e527c108bd1c9380c3',
    messagingSenderId: '986544922490',
    projectId: 'collectioan',
    storageBucket: 'collectioan.firebasestorage.app',
    iosBundleId: 'com.example.collectioan',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA0crQcQigUu_RpGkU4-0yCHi_z_JC_yRk',
    appId: '1:986544922490:web:16dc1c9e267584899380c3',
    messagingSenderId: '986544922490',
    projectId: 'collectioan',
    authDomain: 'collectioan.firebaseapp.com',
    storageBucket: 'collectioan.firebasestorage.app',
    measurementId: 'G-3H11SYL4DQ',
  );
}
