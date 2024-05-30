import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:green_watch_app/components/my_drawer.dart';
import 'package:green_watch_app/main.dart';
import 'package:green_watch_app/pages/settings_page.dart';
import 'package:flutter/material.dart';

import 'package:green_watch_app/pages/profile_page.dart';

import 'package:firebase_auth/firebase_auth.dart';

class HomeClient extends StatefulWidget {
  const HomeClient({super.key});

  @override
  State<HomeClient> createState() => _HomeClientState();
}

class _HomeClientState extends State<HomeClient> {
  final Future<FirebaseApp> _fApp = Firebase.initializeApp();
  String tempValue = '0';
  String humValue = '0';
  String lumValue = '0';
  String soilValue = '0';

  DateTime? lastTempNotificationTime;
  DateTime? lastHumNotificationTime;
  DateTime? lastLumNotificationTime;
  DateTime? lastSoilNotificationTime;

  void signUserOut() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Log Out'),
            content: const Text('Are you sure you want to sign out?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    FirebaseAuth.instance.signOut();
                  },
                  child: const Text('Log Out')),
            ],
          );
        });
  }

  void goToSettingsPage() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Settings(),
      ),
    );
  }

  void goToProfilePage() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Profile(),
      ),
    );
  }

  Future<void> showTempNotification(String temperature) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Temperature Alert',
      'The temperature is $temperature°C',
      platformChannelSpecifics,
      payload: 'HomePage',
    );
  }

  Future<void> showHumNotification(String humidity) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Humidity Alert',
      'The humidity is $humidity%',
      platformChannelSpecifics,
      payload: 'HomePage',
    );
  }

  Future<void> showLumNotification(String luminosity) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Luminosity Alert',
      'The Luminosity is $luminosity LUX',
      platformChannelSpecifics,
      payload: 'HomePage',
    );
  }

  Future<void> showSoilNotification(String soilHumidity) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Soil Humidity Alert',
      'The soil is dry',
      platformChannelSpecifics,
      payload: 'HomePage',
    );
  }

  String getTemperatureImage(double temperature) {
    if (temperature < 18) {
      return 'assets/Ltemperature.png';
    } else if (temperature > 24) {
      return 'assets/Htemperature.png';
    } else {
      return 'assets/temperature.png';
    }
  }

  String getHumidityImage(double humidity) {
    if (humidity < 40) {
      return 'assets/Lhumidity.png';
    } else if (humidity > 80) {
      return 'assets/Hhumidity.png';
    } else {
      return 'assets/humidity.png';
    }
  }

  String getLuminosityImage(double luminosity) {
    if (luminosity < 60) {
      return 'assets/Llight.png';
    } else if (luminosity > 120) {
      return 'assets/Hlight.png';
    } else {
      return 'assets/light.png';
    }
  }

  String getSoilHumImage(double soilHum) {
    if (soilHum == 1) {
      return 'assets/soil.png';
    } else {
      return 'assets/Lsoil.png';
    }
  }

  final user = FirebaseAuth.instance.currentUser!;

  Widget consult() {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('UsersData');
    var userid = user.uid;
    final userUid = ref.child(userid.toString());
    final readings = userUid.child('readings');
    final temperature = readings.child('temperature');
    final humidity = readings.child('humidity');
    final luminosity = readings.child('luminosity');
    final soilHumidity = readings.child('soil');

    temperature.onValue.listen(
      (event) {
        setState(() {
          tempValue = event.snapshot.value.toString();
          if (double.tryParse(tempValue) != null &&
                  double.parse(tempValue) < 18 ||
              double.parse(tempValue) > 24) {
            final now = DateTime.now();
            if (lastTempNotificationTime == null ||
                now.difference(lastTempNotificationTime!) >=
                    const Duration(seconds: 30)) {
              showTempNotification(tempValue);
              lastTempNotificationTime = now;
            }
          }
        });
      },
    );

    humidity.onValue.listen(
      (event) {
        setState(() {
          humValue = event.snapshot.value.toString();
          if (double.tryParse(humValue) != null &&
                  double.parse(humValue) < 40 ||
              double.parse(humValue) > 80) {
            final now = DateTime.now();
            if (lastHumNotificationTime == null ||
                now.difference(lastHumNotificationTime!) >=
                    const Duration(seconds: 35)) {
              showHumNotification(humValue);
              lastHumNotificationTime = now;
            }
          }
        });
      },
    );
    luminosity.onValue.listen(
      (event) {
        setState(() {
          lumValue = event.snapshot.value.toString();
          if (double.tryParse(lumValue) != null &&
                  double.parse(lumValue) < 60 ||
              double.parse(lumValue) > 120) {
            final now = DateTime.now();
            if (lastLumNotificationTime == null ||
                now.difference(lastLumNotificationTime!) >=
                    const Duration(seconds: 25)) {
              showLumNotification(lumValue);
              lastLumNotificationTime = now;
            }
          }
        });
      },
    );

    soilHumidity.onValue.listen(
      (event) {
        setState(() {
          soilValue = event.snapshot.value.toString();
          if (double.tryParse(soilValue) != null &&
              double.parse(soilValue) == 0) {
            final now = DateTime.now();
            if (lastSoilNotificationTime == null ||
                now.difference(lastSoilNotificationTime!) >=
                    const Duration(seconds: 20)) {
              showSoilNotification(soilValue);
              lastSoilNotificationTime = now;
            }
          }
        });
      },
    );
    double temp = double.tryParse(tempValue) ?? 0;
    double hum = double.tryParse(humValue) ?? 0;
    double lum = double.tryParse(lumValue) ?? 0;
    double soiHum = double.tryParse(soilValue) ?? 0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.green[400],
                ),
                padding: const EdgeInsets.all(20.0),
                child: const Column(
                  children: [
                    SizedBox(height: 5),
                    Center(
                      child: Text(
                        "GreenWatch Pro",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Text(
          "Your Plants Our Priority",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 30),
        // temperature and humidity
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // temperature card

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Column(
                  children: [
                    Text(
                      "Temperature",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white.withOpacity(0.75),
                      image: DecorationImage(
                          image: AssetImage(getTemperatureImage(temp)),
                          fit: BoxFit.cover)),
                  padding: const EdgeInsets.all(15),
                ),
                const SizedBox(height: 10),
                Text(
                  '$tempValue °C',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black),
                ),
              ],
            ),

            // luminosity card

            Column(
              children: [
                const Column(
                  children: [
                    Text(
                      "Luminosity",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white.withOpacity(0.75),
                      image: DecorationImage(
                          image: AssetImage(getLuminosityImage(lum)),
                          fit: BoxFit.cover)),
                  padding: const EdgeInsets.all(15),
                ),
                const SizedBox(height: 10),
                Text(
                  '$lumValue LUX',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 50,
        ),
        // humidity and soil
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // soil humidity card

            // humidity card

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Column(
                  children: [
                    Text(
                      "Humidity",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white.withOpacity(0.75),
                      image: DecorationImage(
                          image: AssetImage(getHumidityImage(hum)),
                          fit: BoxFit.cover)),
                  padding: const EdgeInsets.all(15),
                ),
                const SizedBox(height: 10),
                Text(
                  '$humValue %',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black),
                ),
              ],
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Column(
                  children: [
                    Text(
                      "Soil Humidity",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white.withOpacity(0.75),
                      image: DecorationImage(
                          image: AssetImage(getSoilHumImage(soiHum)),
                          fit: BoxFit.cover)),
                  padding: const EdgeInsets.all(15),
                ),
                const SizedBox(height: 10),
                Text(
                  soilValue == '1' ? 'Wet' : 'Dry',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.green[600],
        title: const Text(
          "Home",
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onSettingsTap: goToSettingsPage,
        onLogOutTap: signUserOut,
      ),
      body: FutureBuilder(
        future: _fApp,
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Something wrong with firebase");
          } else if (snapshot.hasData) {
            return consult();
          } else {
            return const CircularProgressIndicator();
          }
        }),
      ),
    );
  }
}
