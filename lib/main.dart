import 'package:flutter/material.dart';
import 'package:gadeer/config/binding.dart';
import 'package:gadeer/modules/app/application.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppBinding.initAsyncDependencies();

  runApp(Application());
}
