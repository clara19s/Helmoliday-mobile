import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  _checkAuthentication() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'jwt_token');

    if (token != null && token.isNotEmpty) {
      print("[SPLASH SCREEN] User is authenticated");
      print("Token: $token");
      context.go('/home');
    } else {
      print("[SPLASH SCREEN] User is not authenticated");
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Color(0xff0f70b7),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage("assets/images/logo.png"),
                  width: 150,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 16, 0, 48),
                  child: Text(
                    "HELMoliday",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 32,
                      color: Color(0xffffffff),
                    ),
                  ),
                ),
                CircularProgressIndicator(
                  color: Colors.white,
                )
              ]),
        ));
  }
}
