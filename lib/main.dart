import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:provider/provider.dart';
import 'package:taxverse_admin/controller/providers/applicatincheck_provider.dart';
import 'package:taxverse_admin/controller/providers/auth_provider.dart';
import 'package:taxverse_admin/controller/providers/chatRoom_provider.dart';
import 'package:taxverse_admin/view/sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  var result = await FlutterNotificationChannel.registerNotificationChannel(
    description: 'For Showing Message Notifications',
    id: 'chats',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'Chats',
  );
  log('Notification Channel $result');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(FirebaseAuth.instance),
        ),
        StreamProvider(create: (context) => context.watch<AuthProvider>().stream(), initialData: null),
        ChangeNotifierProvider<AppliacationCheckProvider>(
          create: (context) => AppliacationCheckProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChatRoomProvider(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(),
        home: const SignIn(),
      ),
    );
  }
}
