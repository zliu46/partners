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
    apiKey: 'AIzaSyCbcOfq4e3A0w8NpA2BWkNvcLQdvEfptGw',
    appId: '1:504716019464:web:e6849515a88afc8f2a0ebd',
    messagingSenderId: '504716019464',
    projectId: 'partnersapp-231a5',
    authDomain: 'partnersapp-231a5.firebaseapp.com',
    storageBucket: 'partnersapp-231a5.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDm3o4_gHXBUn_c8zg1O1fdSeG2brgdBac',
    appId: '1:504716019464:android:90b6cda976f5a4582a0ebd',
    messagingSenderId: '504716019464',
    projectId: 'partnersapp-231a5',
    storageBucket: 'partnersapp-231a5.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBhsDiVVZAwb8N2i4K7xRZ6u6kpHAsTDA0',
    appId: '1:504716019464:ios:d97a08f07a04ddc42a0ebd',
    messagingSenderId: '504716019464',
    projectId: 'partnersapp-231a5',
    storageBucket: 'partnersapp-231a5.firebasestorage.app',
    iosBundleId: 'com.example.partners',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBhsDiVVZAwb8N2i4K7xRZ6u6kpHAsTDA0',
    appId: '1:504716019464:ios:d97a08f07a04ddc42a0ebd',
    messagingSenderId: '504716019464',
    projectId: 'partnersapp-231a5',
    storageBucket: 'partnersapp-231a5.firebasestorage.app',
    iosBundleId: 'com.example.partners',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCbcOfq4e3A0w8NpA2BWkNvcLQdvEfptGw',
    appId: '1:504716019464:web:6c0651ed4300fffc2a0ebd',
    messagingSenderId: '504716019464',
    projectId: 'partnersapp-231a5',
    authDomain: 'partnersapp-231a5.firebaseapp.com',
    storageBucket: 'partnersapp-231a5.firebasestorage.app',
  );
}
