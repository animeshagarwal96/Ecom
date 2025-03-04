import 'package:ecom/router/app_router.dart';
import 'package:ecom/screen_util/src/screen_util.dart';
import 'package:ecom/screen_util/src/screenutil_init.dart';
import 'package:ecom/utils/app_utils.dart';
import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
final scaffoldkey = GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (!FocusScope.of(context).hasPrimaryFocus &&
            FocusScope.of(context).focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: ScreenUtilInit(
          //minTextAdapt: true,
          scale: AppUtils.isTablet ? 0.85 : 1.05,
          designSize: const Size(414, 896),
          builder: (BuildContext context, Widget? child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Ecom',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              onGenerateRoute: AppRouter().onGenerateRoute,
            );
          }),
    );
  }
}
