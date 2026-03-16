// import 'dart:convert'; // jsonEncode ke liye
// import 'package:http/http.dart' as http; // API call ke liye
// import 'package:firebase_messaging/firebase_messaging.dart';
//
// class FcmTokenRepository {
//   final FirebaseMessaging _messaging = FirebaseMessaging.instance;
//
//   Future<void> fetchAndSaveFcmToken(String userId) async {
//     try {
//       String? token = await _messaging.getToken();
//
//       print("👉 userId: $userId");
//       print("👉 FCM Token: $token");
//
//       if (token == null) {
//         print("❌ FCM token null mila");
//         return;
//       }
//
//       final url = Uri.parse("https://api.fetchtrue.com/api/notifications/save-fcm-token");
//
//       final response = await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "userId": userId,
//           "fcmToken": token,
//         }),
//       );
//
//       print("👉 API Response: ${response.statusCode} - ${response.body}");
//     } catch (e) {
//       print("❌ Exception: $e");
//     }
//   }
//
//   void listenTokenRefresh(String userId) {
//     _messaging.onTokenRefresh.listen((newToken) async {
//       print("🔄 Refreshed FCM Token: $newToken");
//
//       final url = Uri.parse("https://api.fetchtrue.com/api/notifications/save-fcm-token");
//
//       await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "userId": userId,
//           "fcmToken": newToken,
//         }),
//       );
//     });
//   }
// }
