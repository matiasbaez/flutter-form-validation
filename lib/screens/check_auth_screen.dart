
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:products/services/services.dart';
import 'package:products/screens/screens.dart';

class CheckAuthScreen extends StatelessWidget {

  static String routerName = 'CheckAuth';

  const CheckAuthScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      body: FutureBuilder(
        future: authService.isAuthenticated(),
        builder: (BuildContext _, AsyncSnapshot<String> snapshot) {

          if ( !snapshot.hasData ) return const Text('Loading');

          Future.microtask(() {
            final redirectTo = ( snapshot.data == '') ? const LoginScreen() : const HomeScreen();
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: ( _, __, ___) => redirectTo,
                transitionDuration: const Duration( seconds: 0 )
              )
            );
          });

          return Container();
        },
      ),
    );
  }
}