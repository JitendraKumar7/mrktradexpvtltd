import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';

GetIt locator = GetIt.I;

void setupLocator() {
  locator.registerSingleton(UrlLauncherService());
  //locator.registerLazySingleton(() => PushNotificationService());
}

class UrlLauncherService {
  void call(String number) => launch('tel:$number');

  void sendSms(String number) => launch('sms:$number');

  void sendEmail(String email) => launch('mailto:$email');

  void launchUrl(url) => launch(url);

  void googleMap(lat, lon) =>
      launch('https://www.google.com/maps/search/?api=1&query=$lat,$lon');
}

// Example

//final CallsAndMessagesService _service = locator<CallsAndMessagesService>();
//_service.call(number)
