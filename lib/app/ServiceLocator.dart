import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

GetIt locator = GetIt.I;

void setupLocator() {
  locator.registerSingleton(UrlLauncherService());
  locator.registerLazySingleton(() => PushNotificationService());
}

class UrlLauncherService {
  void call(String number) => launch('tel:$number');

  void sendSms(String number) => launch('sms:$number');

  void sendEmail(String email) => launch('mailto:$email');

  void launchUrl(url) => launch(url);

  void googleMap(lat, lon) =>
      launch('https://www.google.com/maps/search/?api=1&query=$lat,$lon');
}

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  static final notificationsPlugin = FlutterLocalNotificationsPlugin();

  _showNotification(int id, String title, String body, String payload) async {
    await notificationsPlugin.show(
      id,
      '$id $title',
      body,
      NotificationDetails(
        AndroidNotificationDetails(
            'mrk_channel_id', 'mrk_channel_name', 'mrk_channel_description',
            importance: Importance.Max,
            priority: Priority.High,
            ticker: 'ticker'),
        IOSNotificationDetails(),
      ),
      payload: payload,
    );
  }

  void register() => _fcm.getToken().then((token) => print(token));

  Future<String> getToken() => _fcm.getToken();

  FirebaseMessaging getFcm() => _fcm;

  void initialise() {
    _fcm.requestNotificationPermissions();
    _fcm.configure(onMessage: (Map<String, dynamic> message) async {
      _showNotification(0, message['data']['title'], message['data']['body'],
          message['data']['url']);
      print('onMessage: $message');
    }, onLaunch: (Map<String, dynamic> message) async {
      _showNotification(1, message['data']['title'], message['data']['body'],
          message['data']['url']);
      print('onLaunch: $message');
    }, onResume: (Map<String, dynamic> message) async {
      _showNotification(2, message['data']['title'], message['data']['body'],
          message['data']['url']);
      print('onResume: $message');
    });
  }

}

// Example

//final CallsAndMessagesService _service = locator<CallsAndMessagesService>();
//_service.call(number)
