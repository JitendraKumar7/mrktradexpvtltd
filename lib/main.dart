import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'ui/base/libraryExport.dart';
import 'dart:async';
import 'dart:io';
import 'dart:ui';

var appLaunch;

final navigatorKey = GlobalKey<NavigatorState>();
final notificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> _showNotification(int id, Map<String, dynamic> message) async {
  // Show a notification after every 15 minute with the first
  // appearance happening a minute after invoking the method

  /*final MethodChannel platform =
      MethodChannel('crossingthestreams.io/resourceResolver');
  String alarmUri = await platform.invokeMethod('getAlarmUri');*/
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'mrktradexpvtltd1', 'mrk tradex', 'mrk tradex pvt ltd',
    //sound: RawResourceAndroidNotificationSound('slow_spring_board'),
    importance: Importance.Max,
    priority: Priority.High,
    playSound: true,
  );
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();

  // initialise channel platform for both Android and iOS device.
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await notificationsPlugin.show(
    id,
    '${message['data']['title']}',
    message['data']['body'],
    platformChannelSpecifics,
    payload: jsonEncode(message),
  );
}

Future<dynamic> onBackgroundMessageHandler(Map<String, dynamic> message) async {
  _showNotification(3, message);
  print('onBackgroundMessage: $message');
  return Future<void>.value();
}

class NotificationHandler {
  static final NotificationHandler _singleton = NotificationHandler._internal();
  final FirebaseMessaging _fcm = FirebaseMessaging();

  factory NotificationHandler() {
    return _singleton;
  }

  NotificationHandler._internal();


  Future<void> initialise() async {
    var initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        _showNotification(0, message);
        print('onMessage: $message');
      },
      onBackgroundMessage: Platform.isIOS ? null : onBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        _showNotification(2, message);
        print('onLaunch: $message');
      },
      onResume: (Map<String, dynamic> message) async {
        _showNotification(3, message);
        print('onResume: $message');
      },
    );
  }

  Future<String> getToken() async => _fcm.getToken();

  Future<void> onSelectNotification(String payload) async {
    Map result = jsonDecode(payload);
    String url = result['data']['url'];
    if (appLaunch?.didNotificationLaunchApp ?? false) {
      print('SelectNotificationLaunchApp $url');
    }
    // app already opened
    else if (url.isNotEmpty) {
      print('SelectNotification url $url');
      await navigatorKey.currentState.push(
        MaterialPageRoute(
          builder: (context) => InAppWebViewPage(url: url),
        ),
      );
    }
  }

  Future<void> register() => getToken().then((token) => print(token));

  Future<void> onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    print('onDidReceiveLocalNotification $payload');
  }

}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  appLaunch = await notificationsPlugin.getNotificationAppLaunchDetails();

  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  NotificationHandler handler;

  @override
  void initState() {
    super.initState();
    handler = NotificationHandler();
    handler.initialise();
    handler.register();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(
        splash: true,
      ),
      title: 'APP',
    );
  }
}

// Splash Screen start
class SplashScreen extends StatefulWidget {
  final bool splash;

  const SplashScreen({Key key, this.splash = false}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.splash) {
      if (appLaunch?.didNotificationLaunchApp ?? false) {
        print('InAppWebViewPage ${appLaunch?.payload}');
        Map result = jsonDecode(appLaunch?.payload);
        String url = result['data']['url'];
        print('SelectNotification url $url');
        if (url.isNotEmpty) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => InAppWebViewPage(url: url),
            ),
            (Route<dynamic> route) => false,
          );
        }
      }
      // normal app
      else {
        var duration = const Duration(milliseconds: 3000);
        Future.delayed(duration, openDashboard);
      }
    } else {
      openDashboard();
    }
  }

  void openDashboard() async {
    Map response = (await ApiClient().getCardDetails()).data;

    if (response['status'] == '200') {
      Map result = response['result'];
      String key1 = AppConstants.KONNECT_DATA;
      AppPreferences.setString(key1, jsonEncode(result));
      KonnectDetails details = KonnectDetails.fromJson(result);

      String key2 = AppConstants.USER_LOGIN_CREDENTIAL;
      var credential = await AppPreferences.getString(key2);

      UserLogin login = UserLogin.formJson(credential);

      if (login.isLogin) {
        Map params = Map();
        String deviceId = await _getId();
        String fcmToken = await NotificationHandler().getToken();
        String userType = login.userType.toString().split('.').last;

        params['serverKey'] = AppConstants.getServerKey;
        params['loginId'] = login.loginId;
        params['userType'] = userType;
        params['fcmToken'] = fcmToken;
        params['deviceId'] = deviceId;

        Map response = (await ApiClient().checkedLogin(params)).data;

        if (response['status'] == '200' || login.isMaster) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: getBuilder(login, details),
            ),
            (Route<dynamic> route) => false,
          );
        }
        // log out admin
        else {
          AwesomeDialog(
              context: context,
              dismissOnTouchOutside: false,
              dialogType: DialogType.INFO,
              animType: AnimType.BOTTOMSLIDE,
              title: 'Logout',
              desc: 'Logout',
              body: Text(
                'User already login another device',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              btnOkText: 'Logout',
              btnOkOnPress: () {
                logout(details);
              }).show();
        }
      }
      // log out
      else {
        logout(details);
      }
    }
  }

  Future<String> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor
          .toUpperCase(); // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId.toUpperCase(); // unique ID on Android
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(0, 0),
        child: Container(),
      ),
      body: widget.splash
          ? Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/splash_screen.jpg'),
                    fit: BoxFit.cover),
              ),
            )
          : Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: GFLoader(loaderColorOne: Colors.white),
              ),
            ),
    );
  }

  void logout(KonnectDetails details) {
    UserLogin login = UserLogin.formJson(null);
    String key = AppConstants.USER_LOGIN_CREDENTIAL;
    AppPreferences.setString(key, jsonEncode(login.toJson()));

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => DashboardScreen(details),
      ),
      (Route<dynamic> route) => false,
    );
  }

  WidgetBuilder getBuilder(UserLogin login, KonnectDetails details) {
    if (login.isMaster)
      return (BuildContext ctx) => PartyDashboardScreen(details);
    if (login.isLinked)
      return (BuildContext ctx) => LinkUserDashboardScreen(details);
    if (login.isSuper)
      return (BuildContext ctx) => AdminDashboardScreen(details, 'Admin');
    if (login.isAdmin)
      return (BuildContext ctx) => AdminDashboardScreen(details, 'Co-Admin');
    // if any mistake
    return (BuildContext context) => DashboardScreen(details);
  }
}
