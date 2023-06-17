import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gadeer/config/app_pages.dart';
import 'package:gadeer/config/binding.dart';
import 'package:gadeer/config/routes.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/modules/consultants_home/widget/show_profile_page_byId.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_links/uni_links.dart';

class Application extends StatefulWidget {
  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application>{

  final FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: Get.find<FirebaseAnalytics>());


  bool _initialURILinkHandled = false;
  Uri? _initialURI;
  Uri? _currentURI;
  Object? _err;

  StreamSubscription? _streamSubscription;

  Future<void> _initURIHandler() async {
    // 1
    if (!_initialURILinkHandled) {
      _initialURILinkHandled = true;

      try {
        // 3
        final initialURI = await getInitialUri();
        // 4
        if (initialURI != null) {
          debugPrint("Initial URI received $initialURI");
          if (!mounted) {
            return;
          }
          setState(() {
            _initialURI = initialURI;
          });
          print('${_initialURI?.path.split('/')}');
          String? id = _initialURI?.path.split('/')[2];
          print(id);
          Get.to(ShowProfilePageId(id: int.parse(id!),));
        } else {
          debugPrint("Null Initial URI received");
        }
      } on PlatformException { // 5
        debugPrint("Failed to receive initial uri");
      } on FormatException catch (err) { // 6
        if (!mounted) {
          return;
        }
        debugPrint('Malformed Initial URI received');
        setState(() => _err = err);
      }
    }
  }

  void _incomingLinkHandler() {
    // 1
    if (!kIsWeb) {
      // 2
      _streamSubscription = uriLinkStream.listen((Uri? uri) {
        if (!mounted) {
          return;
        }
        debugPrint('Received URI: $uri');

        setState(() {
          _currentURI = uri;
          _err = null;
        });
        print('${_currentURI?.path.split('/')}');
        String? id = _currentURI?.path.split('/')[2];
        print(id);
        Get.to(ShowProfilePageId(id: int.parse(id!),));
        // 3
      }, onError: (Object err) {
        if (!mounted) {
          return;
        }
        debugPrint('Error occurred: $err');
        setState(() {
          _currentURI = null;
          if (err is FormatException) {
            _err = err;
          } else {
            _err = null;
          }
        });
      });
    }
  }


  // Future<void> initUniLinks() async {
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     final initialLink = await getInitialLink();
  //     // Parse the link and warn the user, if it is not correct,
  //     // but keep in mind it could be `null`.
  //    Get.to(ShowProfilePageId(id: 13,));
  //     print(initialLink);
  //   } on PlatformException {
  //     // Handle exception by warning the user their action did not succeed
  //     // return?
  //   }
  // }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   switch (state) {
  //     case AppLifecycleState.resumed:
  //       print("app in resumed");
  //       // initUniLinks();
  //       break;
  //     case AppLifecycleState.inactive:
  //       print("app in inactive");
  //       break;
  //     case AppLifecycleState.paused:
  //       print("app in paused");
  //       break;
  //     case AppLifecycleState.detached:
  //       print("app in detached");
  //       break;
  //   }
  //
  // }

  @override
  void initState() {
    super.initState();
    //WidgetsBinding.instance.addObserver(this);
    _initURIHandler();
    _incomingLinkHandler();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    //WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

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
