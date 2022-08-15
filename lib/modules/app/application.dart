import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gadeer/config/app_pages.dart';
import 'package:gadeer/config/binding.dart';
import 'package:gadeer/config/routes.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Application extends StatelessWidget {
  final FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: Get.find<FirebaseAnalytics>());
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorObservers: [observer],
      initialBinding: AppBinding(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: Locale('ar', 'SA'),
      supportedLocales: [
        Locale('ar', 'SA'),
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarIconBrightness: Brightness.light,
                statusBarBrightness: Brightness.dark,
                systemStatusBarContrastEnforced: true,
                statusBarColor: AppColors.primary)),
        fontFamily: GoogleFonts.cairo().fontFamily,
        brightness: Brightness.light,
      ),
      smartManagement: SmartManagement.keepFactory,
      initialRoute: Routes.splash,
      getPages: AppPages.pages,
    );
  }
}
