import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gadeer/config/binding.dart';
import 'package:gadeer/modules/app/application.dart';


class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main() async {
  HttpOverrides.global = new MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await AppBinding.initAsyncDependencies();

  runApp(Application());
}
