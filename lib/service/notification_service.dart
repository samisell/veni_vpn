import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  static NotificationService get instance => _instance;

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  bool isCallingScreenOpen = false;

  void setCallingScreenStatus(bool status) {
    isCallingScreenOpen = status;
  }

  static Future<void> startListeningNotificationEvents() async {
    AwesomeNotifications()
        .setListeners(onActionReceivedMethod: onActionReceivedMethod);
  }

  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    if (receivedAction.actionType == ActionType.Default) {
      // AwesomeNotifications().dismissAllNotifications();
      return instance.onActionReceivedImplementationMethod(receivedAction);
    } else {
      // AwesomeNotifications().dismissAllNotifications();
    }
  }

  Future<void> onActionReceivedImplementationMethod(
      ReceivedAction receivedAction) async {
    String? adId = receivedAction.payload?['ad_id'];
    if (adId != null) {
      // FadeScreenTransition(
      //   routeName: Routes.postDetailsRoute,
      //   params: {"adsId": adId},
      // ).navigate();
    }
  }

  Future<void> ensureNotificationPermission(
      {bool isForcePermission = false}) async {
    var status = await Permission.notification.status;

    if (status.isDenied || status.isRestricted && isForcePermission) {
      var requestResult = await Permission.notification.request();
      if (requestResult.isPermanentlyDenied) {
        openAppSettings();
      } else {
        ensureNotificationPermission();
      }
    }
  }
}
