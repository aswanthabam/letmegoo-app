import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:letmegoo/services/device_service.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static String? _pendingToken;

  /// Initialize Firebase Messaging
  static Future<void> initialize() async {
    try {
      // Request permissions first
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      print('Notification permission status: ${settings.authorizationStatus}');

      // Only proceed if authorized
      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        
        // Get initial token but don't update yet
        final token = await _messaging.getToken();
        if (token != null) {
          print('Initial FCM token retrieved: ${token.substring(0, 10)}...');
          _pendingToken = token;
        }

        // Set up token refresh listener
        FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
          print('Token refreshed');
          _handleTokenRefresh(newToken);
        });

        // Set up message handlers
        _setupMessageHandlers();
        
        // Listen for auth state changes to update token when user logs in
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
          if (user != null && _pendingToken != null) {
            print('User authenticated, updating pending token');
            DeviceService.updateDeviceToken(_pendingToken!);
            _pendingToken = null; // Clear after updating
          }
        });
      }
    } catch (e) {
      print('Error initializing notifications: $e');
      // Don't throw - let app continue without notifications
    }
  }

  static void _handleTokenRefresh(String newToken) async {
    // Check if user is authenticated
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // User is logged in, update immediately
      await DeviceService.updateDeviceToken(newToken);
    } else {
      // User not logged in, store for later
      _pendingToken = newToken;
      print('Token refresh received but user not authenticated, storing for later');
    }
  }

  static void _setupMessageHandlers() {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received foreground message: ${message.notification?.title}');
      // Handle foreground notifications here
      _handleForegroundMessage(message);
    });

    // Handle background messages (when notification is tapped)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification opened app: ${message.notification?.title}');
      // Handle notification tap here
      _handleNotificationTap(message);
    });

    // Check if app was opened from a notification
    _checkInitialMessage();
  }

  static Future<void> _checkInitialMessage() async {
    // Get any messages which caused the application to open from terminated state
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    
    if (initialMessage != null) {
      print('App opened from notification: ${initialMessage.notification?.title}');
      _handleNotificationTap(initialMessage);
    }
  }

  static void _handleForegroundMessage(RemoteMessage message) {
    // Handle the message when app is in foreground
    // You might want to show a local notification here
    if (message.notification != null) {
      print('Notification Title: ${message.notification!.title}');
      print('Notification Body: ${message.notification!.body}');
    }
    
    // Handle data payload
    if (message.data.isNotEmpty) {
      print('Message data: ${message.data}');
    }
  }

  static void _handleNotificationTap(RemoteMessage message) {
    // Handle navigation based on notification data
    if (message.data.isNotEmpty) {
      // Example: Navigate to specific screen based on data
      final String? screen = message.data['screen'];
      if (screen != null) {
        // Navigate to the specified screen
        print('Navigate to: $screen');
      }
    }
  }

  /// Call this after successful login to ensure device is registered
  static Future<void> onUserAuthenticated() async {
    try {
      // Ensure device is registered
      await DeviceService.ensureDeviceRegistered();
      
      // If we have a pending token, update it now
      if (_pendingToken != null) {
        await DeviceService.updateDeviceToken(_pendingToken!);
        _pendingToken = null;
      }
    } catch (e) {
      print('Error in onUserAuthenticated: $e');
    }
  }

  /// Call this before logout
  static Future<void> onUserLogout() async {
    try {
      await DeviceService.unregisterDevice();
    } catch (e) {
      print('Error in onUserLogout: $e');
    }
  }
}