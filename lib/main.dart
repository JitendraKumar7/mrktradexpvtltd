import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/subjects.dart';
import 'ui/base/libraryExport.dart';
import 'dart:async';
import 'dart:io';
import 'dart:ui';

var appLaunch;

final selectNotification = BehaviorSubject<String>();

final notificationsPlugin = FlutterLocalNotificationsPlugin();

final receiveNotification = BehaviorSubject<ReceivedNotification>();

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  appLaunch = await notificationsPlugin.getNotificationAppLaunchDetails();

  await notificationsPlugin.initialize(
      InitializationSettings(
        AndroidInitializationSettings('app_icon'),
        IOSInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
            onDidReceiveLocalNotification:
                (int id, String title, String body, String payload) async {
              receiveNotification.add(
                ReceivedNotification(
                    id: id, title: title, body: body, payload: payload),
              );
            }),
      ), onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    selectNotification.add(payload);
  });
  setupLocator();
  runApp(MyApp());
}

// Received Notification Screen start
class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(
        splash: true,
      ),
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
  final PushNotificationService _pushNotificationService =
      locator<PushNotificationService>();

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

  @override
  void initState() {
    super.initState();

    _requestIOSPermissions();
    _configureSelectNotificationSubject();
    _configureDidReceiveLocalNotificationSubject();

    _pushNotificationService.register();
    _pushNotificationService.getFcm().configure(
        onMessage: (Map<String, dynamic> message) async {
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
    ;

    if (widget.splash) {
      var duration = const Duration(milliseconds: 3000);
      Future.delayed(duration, openDashboard);
    } else {
      openDashboard();
    }
  }

  void _requestIOSPermissions() {
    notificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void _configureSelectNotificationSubject() {
    selectNotification.stream.listen((String payload) async {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InAppWebViewPage(),
        ),
      );
    });
  }

  void _configureDidReceiveLocalNotificationSubject() {
    receiveNotification.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body)
              : null,
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Ok'),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InAppWebViewPage(),
                  ),
                );
              },
            )
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    receiveNotification.close();
    selectNotification.close();
    super.dispose();
  }

  void openDashboard() async {
    if (appLaunch?.didNotificationLaunchApp ?? false) {
      print('app payload ${appLaunch.payload}');
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InAppWebViewPage(payload: appLaunch.payload),
        ),
      );
    }
    // normal app open
    else {
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
          String fcmToken = await _pushNotificationService.getToken();
          String userType = login.userType.toString().split('.').last;

          params['loginId'] = login.loginId;
          params['userType'] = userType;
          params['fcmToken'] = fcmToken;
          params['deviceId'] = deviceId;

          Map response = (await ApiClient().checkedLogin(params)).data;

          if (response['status'] == '200') {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: getBuilder(login, details),
              ),
              (Route<dynamic> route) => false,
            );
          }
          // log out
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

    /* ApiClient().getCardDetails().then((value) {
      setState(() {
        Map response = value.data;
        if (response['status'] == '200') {
          String key1 = AppConstants.KONNECT_DATA;
          String key2 = AppConstants.USER_LOGIN_CREDENTIAL;

          Map<String, dynamic> result = response['result'];

          AppPreferences.setString(key1, jsonEncode(result));
          KonnectDetails details = KonnectDetails.fromJson(result);

          MaterialPageRoute newRoute;
          AppPreferences.getString(key2).then((credential) => {
                setState(() {
                  UserLogin login = UserLogin.formJson(credential);
                  if (login.isSuper && login.isLogin)
                    newRoute = MaterialPageRoute(
                      builder: (BuildContext context) =>
                          AdminDashboardScreen(details, 'Admin'),
                    );
                  else if (login.isAdmin && login.isLogin)
                    newRoute = MaterialPageRoute(
                      builder: (BuildContext context) =>
                          AdminDashboardScreen(details, 'Co-Admin'),
                    );
                  else if (login.isLinked && login.isLogin)
                    newRoute = MaterialPageRoute(
                      builder: (BuildContext context) =>
                          LinkUserDashboardScreen(details),
                    );
                  else if (login.isMaster && login.isLogin)
                    newRoute = MaterialPageRoute(
                      builder: (BuildContext context) =>
                          PartyDashboardScreen(details),
                    );
                  else
                    newRoute = MaterialPageRoute(
                      builder: (BuildContext context) =>
                          DashboardScreen(details),
                    );

                  RoutePredicate predicate = (Route<dynamic> route) => false;
                  Navigator.pushAndRemoveUntil(context, newRoute, predicate);
                })
              });
        }
      });
    });*/
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
