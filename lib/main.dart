import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'route/router.gr.dart';

final appRouter = AppRouter();
final myAppNavigatorKey = appRouter.navigatorKey;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const EvCpmsApp());
}

class EvCpmsApp extends StatelessWidget {
  const EvCpmsApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'EV-CPMS',
      debugShowCheckedModeBanner: false,
      routerDelegate: appRouter.delegate(),
      routeInformationParser: appRouter.defaultRouteParser(),
      theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.lightBlue,
          brightness: Brightness.light),
      darkTheme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.lightBlue,
          appBarTheme: const AppBarTheme(
              iconTheme: IconThemeData(color: Colors.black),
              titleTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 20,
              )),
          brightness: Brightness.dark),
      themeMode: ThemeMode.system,
    );
  }
}
