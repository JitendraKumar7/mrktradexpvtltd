import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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

  void register() => _fcm.getToken().then((token) => print(token));

  Future initialise() async {
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
      },
    );
  }
}

// Example

//final CallsAndMessagesService _service = locator<CallsAndMessagesService>();
//_service.call(number)
