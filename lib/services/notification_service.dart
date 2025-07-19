import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:letmegoo/services/device_service.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Initialize Firebase Messaging
  static Future<void> initialize() async {
    // Request permissions
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    // Handle token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      DeviceService.updateDeviceToken(newToken);
    });

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received foreground message: ${message.notification?.title}');
      // Handle foreground notifications here
    });

    // Handle background messages
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification opened app: ${message.notification?.title}');
      // Handle notification tap here
    });
  }
}
