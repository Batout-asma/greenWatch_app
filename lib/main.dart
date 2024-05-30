import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:green_watch_app/services/layout_page.dart';
import 'package:green_watch_app/services/wrapper.dart';
import 'package:green_watch_app/theme/light_theme.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String databaseURL =
      'https://auth-app-9678a-default-rtdb.europe-west1.firebasedatabase.app';
  String appId = '1:701147182658:android:df1fa6147043d6b57a5fdb';
  String apiKey = 'AIzaSyDgA0NPV3-oko7FMIl_0pPCce62entTUik';
  String messagingSenderId = '701147182658';
  String projectId = 'auth-app-9678a';
  await Firebase.initializeApp(
    options: FirebaseOptions(
      appId: appId,
      apiKey: apiKey,
      databaseURL: databaseURL,
      messagingSenderId: messagingSenderId,
      projectId: projectId,
      storageBucket: "auth-app-9678a.appspot.com",
    ),
  );
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse:
        (NotificationResponse notificationResponse) async {
      if (notificationResponse.payload != null) {
        debugPrint('notification payload: ${notificationResponse.payload}');
        if (notificationResponse.payload == 'HomePage') {
          navigatorKey.currentState?.pushReplacement(
            MaterialPageRoute(builder: (context) => const Layout()),
          );
        }
      }
    },
  );
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      // darkTheme: darkTheme,
      home: const Wrapper(),
    );
  }
}
