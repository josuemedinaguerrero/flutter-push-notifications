// SHA1: 57:A5:05:81:78:29:D6:76:A1:21:8B:41:C6:5B:46:71:B2:A3:43:60

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;

  static final StreamController<String> _messageStream = StreamController.broadcast();

  static Stream<String> get messagesStream => _messageStream.stream;

  static Future _onBackgroundHandler(RemoteMessage message) async {
    // print('onBackground Handler ${message.messageId}');
    _messageStream.add(message.notification?.title ?? 'No message onBackgroundHandler');
    print(message.data);
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    // print('onMessage Handler ${message.messageId}');
    _messageStream.add(message.notification?.title ?? 'No message onMessageHandler');
    print(message.data);
  }

  static Future _onMessageOpenAppHandler(RemoteMessage message) async {
    // print('onMessageOpenApp Handler ${message.messageId}');
    _messageStream.add(message.notification?.title ?? 'No message onMessageOpenAppHandler');
    print(message.data);
  }

  static Future initializeApp() async {
    await Firebase.initializeApp();

    token = await FirebaseMessaging.instance.getToken();
    print('Token: $token');

    // Handlers
    FirebaseMessaging.onBackgroundMessage(_onBackgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenAppHandler);
  }

  static closeStreams() {
    _messageStream.close();
  }
}
