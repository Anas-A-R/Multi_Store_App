import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:supplier_multi_store_app/auth/supplier_login.dart';
import 'package:supplier_multi_store_app/auth/supplier_signup.dart';
import 'package:supplier_multi_store_app/firebase_options.dart';
import 'package:supplier_multi_store_app/main_screens/supplier_home.dart';
import 'package:supplier_multi_store_app/minor_screens/onboarding_screen.dart';
import 'package:supplier_multi_store_app/services/local_notification_services.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('handling background messages: ${message.messageId}');
  print('handling background messages: ${message.notification!.title}');
  print('handling background messages: ${message.notification!.body}');
  print('handling background messages: ${message.data}');
  print('handling background messages: ${message.data['key1']}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.instance.requestPermission();
  NotificationServices().createNotifaicationChannelAndInitialize();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Multi Store',
      initialRoute: '/onboarding',
      routes: {
        '/supplier_home': (context) => const SupplierHomeScreen(),
        '/supplier_signup': (context) => const SupplierRegister(),
        '/supplier_login': (context) => const SupplierLogin(),
        '/onboarding': (context) => const OnboardingScreen(),
      },
    );
  }
}
