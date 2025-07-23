import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import 'ads/ads_callback.dart';
import 'controller/auth_controller.dart';
import 'controller/home_controller.dart';
import 'controller/pref.dart';
import 'data/api/api_client.dart';
import 'service/notification_service.dart';
import 'utils/my_color.dart';
import 'utils/my_helper.dart';
import 'view/screens/splash_screen.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.data.isNotEmpty) {}
}

NotificationService notificationService = NotificationService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  GetStorage storage = GetStorage();
  notificationService.ensureNotificationPermission();
  AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelKey: 'default_channel',
        channelName: 'Push Notifications',
        channelDescription: 'Notify updated news and information',
        ledColor: MyColor.white,
        importance: NotificationImportance.Default,
        channelShowBadge: true,
        enableVibration: true,
        defaultRingtoneType: DefaultRingtoneType.Notification),
  ]);

  const firebaseOptionsAndroid = FirebaseOptions(
    apiKey: 'AIzaSyA0pToLWokfULPBJnu9T6IzLmGRmySjoiM',
    appId: '1:737971595067:android:d62e9cec465e7f2e9f391e',
    messagingSenderId: '737971595067',
    projectId: 'borderless-326fa',
  );

  const firebaseOptionsIOS = FirebaseOptions(
    apiKey: 'AIzaSyA0pToLWokfULPBJnu9T6IzLmGRmySjoiM',
    appId: '1:737971595067:android:d62e9cec465e7f2e9f391e',
    messagingSenderId: '737971595067',
    projectId: 'borderless-326fa',
  );

  try {
    if (Platform.isAndroid) {
      await Firebase.initializeApp(options: firebaseOptionsAndroid);
    } else if (Platform.isIOS) {
      await Firebase.initializeApp(options: firebaseOptionsIOS);
    } else {
      await Firebase.initializeApp();
    }
  } catch (_) {}
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {}
  });
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (storage.read(MyHelper.notification) ?? true) {
      _showNotification(message);
    }
  });

  MobileAds.instance.initialize();
  await UnityAds.init(
    gameId: storage.read(MyHelper.unityAdsAppId) ?? '',
    onComplete: () {},
    onFailed: (error, message) {},
  );
  FacebookAudienceNetwork.init(iOSAdvertiserTrackingEnabled: true);
  await Pref.initializeHive();

  ApiClient myApiClient =
      ApiClient(appBaseUrl: MyHelper.baseUrl, sharedPreferences: storage);

  Get.lazyPut<AdsCallBack>(() => AdsCallBack(),
      fenix: true);
  Get.lazyPut<HomeController>(() => HomeController(apiClient: myApiClient),
      fenix: true);
  Get.lazyPut<AuthController>(() => AuthController(apiClient: myApiClient),
      fenix: true);

  runApp(
    Phoenix(
      child: const MyApp(),
    ),
  );
}

int generateNotificationId() {
  return DateTime.now().millisecondsSinceEpoch.remainder(2147483647);
}

void _showNotification(RemoteMessage message) {
  final Map<String, dynamic> data = message.data;
  Map<String, String?> stringData =
      data.map((key, value) => MapEntry(key, value?.toString()));
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      channelKey: 'default_channel',
      id: generateNotificationId(),
      title: message.notification?.title ?? 'New Notification',
      body: message.notification?.body ??
          'You have a new message from ${MyHelper.appname}.',
      backgroundColor: MyColor.white,
      bigPicture: data['image'],
      autoDismissible: true,
      notificationLayout: NotificationLayout.BigPicture,
      payload: stringData,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: MyColor.bg),
      home: const SplashScreen(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: Builder(
            builder: (context) {
              return child!;
            },
          ),
        );
      },
    );
  }
}
