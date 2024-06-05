// ignore_for_file: avoid_print

import 'package:cloud_functions/cloud_functions.dart';
import 'package:customer_multi_store_app/providers/id_provider.dart';
import 'package:customer_multi_store_app/providers/sql_helper.dart';
import 'package:customer_multi_store_app/providers/wishlist_sql_helper.dart';
import 'package:customer_multi_store_app/services/notification_services.dart';
import 'package:customer_multi_store_app/test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:customer_multi_store_app/auth/customer_login.dart';
import 'package:customer_multi_store_app/auth/customer_signup.dart';
import 'package:customer_multi_store_app/firebase_options.dart';
import 'package:customer_multi_store_app/main_screens/customer_home.dart';
import 'package:customer_multi_store_app/minor_screens/onboarding_screen.dart';
import 'package:customer_multi_store_app/providers/cart_provider.dart';
import 'package:customer_multi_store_app/providers/stripe_id.dart';
import 'package:customer_multi_store_app/providers/wishlist_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(
      'customer app//////////handling background messages: ${message.messageId}');
  print(
      'customer app//////////handling background messages: ${message.notification!.title}');
  print(
      'customer app//////////handling background messages: ${message.notification!.body}');
  print('customer app//////////handling background messages: ${message.data}');
  print(
      'customer app//////////handling background messages: ${message.data['key1']}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //stripe initialization
  Stripe.publishableKey = publishableKey;
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();
  //firebase initialization
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.instance.requestPermission();
  //notification initialization
  NotificationServices().createNotifaicationChannelAndInitialize();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  //SQL initialization
  SQLHelper.getDatabase;
  WishlistSQLHelper.getDatabase;

  FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
  //run the app

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => Cart()),
    ChangeNotifierProvider(create: (_) => Wishlist()),
    ChangeNotifierProvider(create: (_) => IdProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Multi Store',
      home: MyAppNew(),
      // initialRoute: '/welcome_screen',
      // initialRoute: '/onboarding',

      routes: {
        '/customer_home': (context) => const CustomerHomeScreen(),
        '/customer_signup': (context) => const CustomerRegister(),
        '/customer_login': (context) => const CustomerLogin(),
        '/onboarding': (context) => const OnboardingScreen(),
      },
    );
  }
}
