import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}
class _NotificationScreenState extends State<NotificationScreen> {


  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;


  String? _token;
  // String? token = await _firebaseMessaging.getToken();


  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    print("Handling background message: ${message.messageId}");
  }

  Future<void> _setupFirebaseMessaging() async {
    // Request permission (especially important for iOS)
    await FirebaseMessaging.instance.requestPermission();

    // Get token
    String? token = await FirebaseMessaging.instance.getToken();
    setState(() {
      _token = token;
    });
    print("FCM Token: $token");

    // Foreground message handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📲 Foreground message received: ${message.notification?.title}');
    });

    // When user taps on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('👉 Notification tapped with data: ${message.data}');
    });

    // Background handler (needs to be registered only once)
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  @override
  void initState() {
    super.initState();
    _setupFirebaseMessaging();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: Center(
        child: Text(
          _token != null ? 'FCM Token:\n$_token' : 'Getting token...',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
