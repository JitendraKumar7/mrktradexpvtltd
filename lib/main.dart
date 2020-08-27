import 'ui/base/libraryExport.dart';

void main() {
  setupLocator();
  runApp(MyApp());
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
      home: SplashScreen(splash: true),
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

  @override
  void initState() {
    super.initState();
    _pushNotificationService.register();
    _pushNotificationService.initialise();

    if (widget.splash) {
      var duration = const Duration(milliseconds: 3000);
      Future.delayed(duration, openDashboard);
    } else {
      openDashboard();
    }
  }

  openDashboard() {
    ApiClient().getCardDetails().then((value) {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.splash
        ? Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/splash_screen.jpg'),
                  fit: BoxFit.cover),
            ),
          )
        : Container(
            width: MediaQuery.of(context).size.height,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: GFLoader(loaderColorOne: Colors.white),
            ),
          );
  }
}
