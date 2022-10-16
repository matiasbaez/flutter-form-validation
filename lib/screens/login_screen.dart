
import 'package:flutter/material.dart';

import 'package:products/widgets/widgets.dart';
import 'package:products/ui/ui.dart';

class LoginScreen extends StatelessWidget {

  static String routerName = 'Login';

  const LoginScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: AuthBackgroundWidget(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox( height: 250 ),

              CardContainerWidget(
                child: Column(
                  children: [
                    const SizedBox( height: 10 ),

                    Text('Login', style: Theme.of(context).textTheme.headline4),

                    const SizedBox( height: 30 ),

                    const _LoginForm(),

                  ],
                )
              ),

              const SizedBox( height: 50 ),

              const Text('Create new account', style: TextStyle( fontSize: 18, fontWeight: FontWeight.bold )),

              const SizedBox( height: 50 ),
            ],
          ),
        )
      ),
    );
  }

}


class _LoginForm extends StatelessWidget {

  const _LoginForm({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Container(
      child: Form(
        child: Column(
          children: [

            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'jonh.doe@gmail.com',
                labelText: 'Email',
                prefixIcon: Icons.alternate_email_sharp
              )
            ),

            const SizedBox( height: 30 ),

            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: '*****',
                labelText: 'Password',
                prefixIcon: Icons.lock_clock_outlined
              )
            ),

            const SizedBox( height: 30 ),

            MaterialButton(
              shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular( 10 ) ),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.deepPurple,
              child: Container(
                padding: const EdgeInsets.symmetric( horizontal: 80, vertical: 10 ),
                child: const Text('Login', style: TextStyle( color: Colors.white )),
              ),
              onPressed: () {}
            )

          ],
        ),
      ),
    );
  }
}