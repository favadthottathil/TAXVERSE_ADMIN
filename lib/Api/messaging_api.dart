import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';
// import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart';

class MessagingAPI {
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  static getFirebaseMessagingToken() async {
    await fMessaging.requestPermission();

    await fMessaging.getToken().then(
      (t) {
        if (t != null) {
          messageTokenToDatabase(t);
        }
      },
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print(
          'Message also contained a notification: ${message.notification}',
        );
      }
    });
  }

  static sendPushNotification(String messageToken, String message, String userName) async {
    try {
      final body = {
        "to": messageToken,
        "notification": {
          "title": userName,
          "body": message,
          "android_channel_id": "chats",
        },
        "data": {
          "some_data": "User ID: $userName",
        }
      };

      Response response = await post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'key=AAAA0P_GUt4:APA91bHcL44BeKK2BwLMu0L9JfzkA2uFWh4v0wGd8w2j9T8QqT8FQeLZQ2FiBEbj3PRTtWFPIjp2_pNOHThfG3vn11OUSl0n-HlMXyiYfhaI0zZ8fY-To4XyKGqDEv2HR34HMsAykrqn'
        },
        body: jsonEncode(body),
      );
      dev.log('Response Status: ${response.statusCode}');
      dev.log('Response body : ${response.body}');
    } catch (e) {
      ;('error in Message push notification======   $e');
    }
  }

  static messageTokenToDatabase(String token) async {
    try {
      CollectionReference collectionReference = FirebaseFirestore.instance.collection('admins');

      QuerySnapshot querySnapshot = await collectionReference.get();

      for (var doc in querySnapshot.docs) {
        // get the document ID

        String docId = doc.id;

        // update the document by adding a new field

        await collectionReference.doc(docId).update({
          'message_token': token,
        });
      }
      print('Message=====token added');
    } catch (e) {
      print('erro ===== $e');
    }
  }
}

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void requestNotificationPermission() async {
    await messaging.requestPermission();
    // NotificationSettings settings = await messaging.requestPermission(
    //   alert: true,
    //   announcement: true,
    //   badge: true,
    //   carPlay: true,
    //   criticalAlert: true,
    //   provisional: true,
    //   sound: true,
    // );

    // if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    //   print('user granded permission');
    // } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    //   print('user granted provisional permissin');
    // } else {
    //   print('user denied permission');
    // }
  }

  // void initLocalNotifications(BuildContext context, RemoteMessage message) async {
  //   var androidInitializationSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
  //   var iosInitializationSettings = const DarwinInitializationSettings();

  //   var initializationSetting = InitializationSettings(
  //     android: androidInitializationSettings,
  //     iOS: iosInitializationSettings,
  //   );

  //   await flutterLocalNotificationsPlugin.initialize(
  //     initializationSetting,
  //     onDidReceiveNotificationResponse: (payload) {},
  //   );
  // }

  Future<void> showNotification(RemoteMessage message) async {
    if (message.notification != null && message.notification!.title != null) {
      AndroidNotificationChannel channel = AndroidNotificationChannel(
        Random.secure().nextInt(1000).toString(),
        'High Importance Notification',
        importance: Importance.max,
      );

      AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        channel.id.toString(),
        channel.name.toString(),
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.max,
        ticker: 'ticker',
        enableVibration: true,
        icon: "@mipmap/ic_launcher",
      );

      DarwinNotificationDetails darwinNotificationDetails = const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails, iOS: darwinNotificationDetails);

      Future.delayed(
        Duration.zero,
        () {
          flutterLocalNotificationsPlugin.show(
            DateTime.now().millisecond,
            message.notification!.title.toString(),
            message.notification!.body.toString(),
            notificationDetails,
          );
        },
      );
    } else if (message.notification!.body != null) {
      // show notification with a body

      AndroidNotificationChannel channel = AndroidNotificationChannel(Random.secure().nextInt(1000).toString(), 'High Importance Notification', importance: Importance.max);

      AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(channel.id.toString(), channel.name.toString(), channelDescription: 'your channel description', importance: Importance.low, priority: Priority.max, ticker: 'ticker', enableVibration: true, icon: "@mipmap/ic_launcher");

      DarwinNotificationDetails darwinNotificationDetails = const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: darwinNotificationDetails,
      );

      Future.delayed(
        Duration.zero,
        () {
          flutterLocalNotificationsPlugin.show(
            DateTime.now().millisecond,
            "",
            message.notification!.body.toString(),
            notificationDetails,
          );
        },
      );
    } else {
      print('failed');
    }
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();

    return token!;
  }

  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
    });
  }

  void firebaseInit() {
    FirebaseMessaging.onMessage.listen((event) {
      if (kDebugMode) {
        print(event.notification!.title.toString());

        print(event.notification!.body.toString());
      }

      showNotification(event);
    });
  }
}
