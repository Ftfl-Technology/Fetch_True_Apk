// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// FlutterLocalNotificationsPlugin();
//
// Future<void> setupInteractedMessage() async {
//   // Terminated state se app open
//   RemoteMessage? initialMessage =
//   await FirebaseMessaging.instance.getInitialMessage();
//
//   if (initialMessage != null) {
//     _handleMessage(initialMessage);
//   }
//
//   // Foreground message
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     print('👉 Foreground message received: ${message.notification?.title}');
//     _showNotification(message);
//   });
//
//   // Background/tap se app open
//   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//     print('👉 Notification opened: ${message.notification?.title}');
//     _handleMessage(message);
//   });
// }
//
// void _handleMessage(RemoteMessage message) {
//   // Notification ke tap pe navigate karna ho to yaha handle karo
//   print("👉 Navigate on tap: ${message.data}");
// }
//
// Future<void> _showNotification(RemoteMessage message) async {
//   const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//     'high_importance_channel',
//     'High Importance Notifications',
//     importance: Importance.max,
//     priority: Priority.high,
//     showWhen: true,
//   );
//
//   const NotificationDetails platformDetails =
//   NotificationDetails(android: androidDetails);
//
//   await flutterLocalNotificationsPlugin.show(
//     message.notification.hashCode,
//     message.notification?.title ?? 'No Title',
//     message.notification?.body ?? 'No Body',
//     platformDetails,
//   );
// }
