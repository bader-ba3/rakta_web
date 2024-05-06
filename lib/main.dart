import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rakta_web/core/binding.dart';
import 'package:rakta_web/layout/auth/auth.dart';
import 'package:rakta_web/layout/home_page/home_page_screen.dart';
import 'package:rakta_web/utils/hive.dart';
import 'package:url_strategy/url_strategy.dart';
import 'const/route.dart';
import 'firebase_options.dart';
import 'layout/auth/check_login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await HiveDataBase.init();
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      initialRoute:  Routes.home,
      getPages: [
        GetPage(
          name: Routes.login,
          page: () { return AuthScreen(); },
        ),
        GetPage(
          name: Routes.home,
          page: () { return HomePageScreen(); },
        ),
        GetPage(
          name: Routes.checkLogin,
          page: () { return CheckLogin(); },
        ),
      ],
      scrollBehavior: AppScrollBehavior(),
      initialBinding: GetBinding(),
      title: 'RAKTA',
      // home: AuthScreen(),
    );
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}


