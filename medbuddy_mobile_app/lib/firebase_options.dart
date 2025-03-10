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
    apiKey: 'AIzaSyAn10rzQ8aCeOryJKvalgwGoEO4BRtaayc',
    appId: '1:452977159547:web:21c7a68c02263b22e9a1de',
    messagingSenderId: '452977159547',
    projectId: 'medbuddy-d75ad',
    authDomain: 'medbuddy-d75ad.firebaseapp.com',
    storageBucket: 'medbuddy-d75ad.firebasestorage.app',
    measurementId: 'G-KZDE9GKT59',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD4KE9DUnK0RFkKdthZJA_PjLYinCwhZ4U',
    appId: '1:452977159547:android:074d654611926816e9a1de',
    messagingSenderId: '452977159547',
    projectId: 'medbuddy-d75ad',
    storageBucket: 'medbuddy-d75ad.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDFq8XIoMMD-7JNYi_NBJ3RDFcwJMg4ZAU',
    appId: '1:452977159547:ios:ae28f0f20e906b0ae9a1de',
    messagingSenderId: '452977159547',
    projectId: 'medbuddy-d75ad',
    storageBucket: 'medbuddy-d75ad.firebasestorage.app',
    iosBundleId: 'com.example.medbuddyMobileApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDFq8XIoMMD-7JNYi_NBJ3RDFcwJMg4ZAU',
    appId: '1:452977159547:ios:ae28f0f20e906b0ae9a1de',
    messagingSenderId: '452977159547',
    projectId: 'medbuddy-d75ad',
    storageBucket: 'medbuddy-d75ad.firebasestorage.app',
    iosBundleId: 'com.example.medbuddyMobileApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAn10rzQ8aCeOryJKvalgwGoEO4BRtaayc',
    appId: '1:452977159547:web:858aa48d75fad0afe9a1de',
    messagingSenderId: '452977159547',
    projectId: 'medbuddy-d75ad',
    authDomain: 'medbuddy-d75ad.firebaseapp.com',
    storageBucket: 'medbuddy-d75ad.firebasestorage.app',
    measurementId: 'G-ZPMZXR96ZV',
  );
}
