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
    apiKey: 'AIzaSyDzBjYGbGd1Nzje8uLN4VM-u69fSt0xKOQ',
    appId: '1:787127091202:web:570388c38d66d05abd671b',
    messagingSenderId: '787127091202',
    projectId: 'vertex-ai-for-firebase',
    authDomain: 'vertex-ai-for-firebase.firebaseapp.com',
    storageBucket: 'vertex-ai-for-firebase.appspot.com',
    measurementId: 'G-02J4LMFYW8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAVqMuYUb3Ni_LekaqwkGoZo4p19B2qthw',
    appId: '1:787127091202:android:b086925a57eea3fcbd671b',
    messagingSenderId: '787127091202',
    projectId: 'vertex-ai-for-firebase',
    storageBucket: 'vertex-ai-for-firebase.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCJKyrldTLMaSf5oT9YMqScL9ch0SfZlSU',
    appId: '1:787127091202:ios:e4018d9aac369bc7bd671b',
    messagingSenderId: '787127091202',
    projectId: 'vertex-ai-for-firebase',
    storageBucket: 'vertex-ai-for-firebase.appspot.com',
    iosBundleId: 'com.example.dynamicTrivia',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCJKyrldTLMaSf5oT9YMqScL9ch0SfZlSU',
    appId: '1:787127091202:ios:e4018d9aac369bc7bd671b',
    messagingSenderId: '787127091202',
    projectId: 'vertex-ai-for-firebase',
    storageBucket: 'vertex-ai-for-firebase.appspot.com',
    iosBundleId: 'com.example.dynamicTrivia',
  );
}
