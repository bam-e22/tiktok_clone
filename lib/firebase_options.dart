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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCrWI9H9WTPUTEX_Y0hzytsa4SS5vCHRC0',
    appId: '1:814802782997:web:60a09c0d8b7f42e47c771c',
    messagingSenderId: '814802782997',
    projectId: 'tiktok-bam-e22',
    authDomain: 'tiktok-bam-e22.firebaseapp.com',
    storageBucket: 'tiktok-bam-e22.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyASk_Z1NDApM5UPttJY9X2TZ9u2wM-KUjI',
    appId: '1:814802782997:android:7ffe9d52cd0b125c7c771c',
    messagingSenderId: '814802782997',
    projectId: 'tiktok-bam-e22',
    storageBucket: 'tiktok-bam-e22.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAI4ByYHkZQtx1ut7q249mehHMvZMQMDZ4',
    appId: '1:814802782997:ios:1a16475c29449e5c7c771c',
    messagingSenderId: '814802782997',
    projectId: 'tiktok-bam-e22',
    storageBucket: 'tiktok-bam-e22.appspot.com',
    iosClientId: '814802782997-58kt7r8qv79qnh41pb8kgivrgj6lh7u1.apps.googleusercontent.com',
    iosBundleId: 'com.chestnut22.tiktokclone',
  );
}
