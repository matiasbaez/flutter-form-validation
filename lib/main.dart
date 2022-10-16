import 'package:flutter/material.dart';

import 'package:products/screens/screens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Products',
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300]
      ),
      initialRoute: LoginScreen.routerName,
      routes: {
        LoginScreen.routerName: (_) => const LoginScreen(),
        HomeScreen.routerName : (_) => const HomeScreen(),
      },
    );
  }
}