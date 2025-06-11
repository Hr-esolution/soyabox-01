import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';


class FirebaseNotifications {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialisation des notifications locales
  void _initializeLocalNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        // ignore: prefer_const_constructors
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Créer un canal de notification pour Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'default_channel',
      'Notifications',
      description: 'Notifications importantes',
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // Affichage des notifications locales
  void _showLocalNotification(RemoteNotification notification) {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'default_channel',
      'Notifications',
      importance: Importance.max,
      priority: Priority.high,
      icon: 'notificationicon',  // Référence à l'icône sans l'extension .png
      playSound: true,
      enableVibration: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    flutterLocalNotificationsPlugin.show(
      0,  // ID de la notification
      notification.title,  // Titre
      notification.body,   // Contenu
      platformChannelSpecifics,
    );
  }

  // Gestion des notifications en premier plan
  void _handleForegroundNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        _showLocalNotification(message.notification!);
      }
    });
  }

  // Demander la permission pour recevoir des notifications
  Future<void> _requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    
    } else {
     
    }
  }

  // Initialisation des notifications
  Future<void> initialize() async {
    await Firebase.initializeApp();
    await _requestPermission();
    _initializeLocalNotifications();
    _handleForegroundNotification();
  }
}
