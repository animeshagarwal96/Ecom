import 'dart:async';
import 'package:ecom/shared_preference/shared_preference_helper.dart';
import 'package:flutter/material.dart';
import 'injection_container/class_injection_container.dart' as di;
import 'injection_container/bloc_injection_container.dart' as diBloc;
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefHelper.init();
  di.init();
  diBloc.init();

  runZonedGuarded(() async {
    runApp(
      (const MyApp()),
    );
  }, (error, stack) => {});
}
