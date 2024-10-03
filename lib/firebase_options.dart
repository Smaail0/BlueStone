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
    apiKey: 'AIzaSyAanqIsGbrA8gORGpfpBATP1oOc0ccaeX8',
    appId: '1:601599538905:web:27aa95a11b8f06729370c8',
    messagingSenderId: '601599538905',
    projectId: 'stegmessage-830d8',
    authDomain: 'stegmessage-830d8.firebaseapp.com',
    storageBucket: 'stegmessage-830d8.appspot.com',
    measurementId: 'G-FF6LS3ZKFC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB7apTfWkfWji3OrEyYKDGAXDGSSu8OehU',
    appId: '1:601599538905:android:4bbd4f78e80e617c9370c8',
    messagingSenderId: '601599538905',
    projectId: 'stegmessage-830d8',
    storageBucket: 'stegmessage-830d8.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCZjXQKCMN5jUohz7S9zPj0RC38hnPtcpM',
    appId: '1:601599538905:ios:b44ecad354936e3c9370c8',
    messagingSenderId: '601599538905',
    projectId: 'stegmessage-830d8',
    storageBucket: 'stegmessage-830d8.appspot.com',
    iosBundleId: 'com.ismailsouissi.stegmessage',
  );
}
