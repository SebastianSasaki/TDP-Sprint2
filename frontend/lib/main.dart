import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:frontend/services/polices-api.services.dart';
import 'package:frontend/services/mini-storage.dart' as storage;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/ui/pages/home_page.dart';
import 'package:frontend/ui/pages/login_page.dart';
import 'package:frontend/ui/pages/register_page.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          headline1: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Color(0XFF232323),
          ),
          headline2: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          headline3: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Color(0XFF232323),
          ),
          headline4: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
            color: Colors.red[300],
          ),
          headline5: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: Color(0XFFB7B7D2),
          ),
          bodyText1: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
          bodyText2: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
            color: Color(0XFFB7B7D2),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    storage.read('policename').then((policename) {
      if (policename != null && policename.isNotEmpty) {
        storage.read('policeId').then((policeId) {
          log("user storaged: policename -> $policename, userId -> $policeId");
          if (policeId != null && policeId.isNotEmpty) {
            _nextPageAfterLogin(context, int.parse(policeId));
          } else {
            log("no está logueado");
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
          }
        });
      } else {
        log("no está logueado");
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/background-splash.PNG',
          fit: BoxFit.cover,
          width: double.infinity,
        ),
        Transform.translate(
            offset: const Offset(0, 200),
            child: Center(
              child: SizedBox(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                width: 40,
                height: 40,
              ),
            )),
      ],
    );
  }

  _nextPageAfterLogin(BuildContext context, int policeId) async {
    PoliceApiService().getByPoliceId(policeId).then((response) {
      if (response.statusCode == 200) {
        log('police: ' + response.data.toString());
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        log("Error getting police: ${response.statusCode}");
      }
    });
  }
}
