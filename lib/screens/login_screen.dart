
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:products/providers/providers.dart';
import 'package:products/screens/screens.dart';
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

                    ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(),
                      child: const _LoginForm(),
                    )

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
  Widget build(BuildContext context) {

    final loginFormProvider = Provider.of<LoginFormProvider>(context, listen: false);

    return Container(
      child: Form(

        key: loginFormProvider.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,

        child: Column(
          children: [

            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'jonh.doe@gmail.com',
                labelText: 'Email',
                prefixIcon: Icons.alternate_email_sharp
              ),
              onChanged: (value) => loginFormProvider.email = value,
              validator: (value) {
                String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp  = new RegExp(pattern);
                return regExp.hasMatch(value ?? '')
                  ? null
                  : 'El correo no es válido';
              },
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
              ),
              onChanged: (value) => loginFormProvider.password = value,
              validator: (value) {
                return (value != null && value.length >= 6)
                  ? null
                  : 'La contraseña debe tener al menos 6 caracteres';
              },
            ),

            const SizedBox( height: 30 ),

            MaterialButton(
              shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular( 10 ) ),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.deepPurple,
              onPressed: loginFormProvider.isLoading ? null : () async {

                FocusScope.of(context).unfocus();

                if (!loginFormProvider.isValidForm()) return;

                loginFormProvider.isLoading = true;

                await Future.delayed(const Duration(seconds: 2));

                loginFormProvider.isLoading = false;

                Navigator.pushReplacementNamed(context, HomeScreen.routerName);
              },
              child: Container(
                padding: const EdgeInsets.symmetric( horizontal: 80, vertical: 10 ),
                child: Text(
                  loginFormProvider.isLoading
                    ? 'Iniciando...'
                    : 'Login',
                  style: const TextStyle( color: Colors.white )
                ),
              )
            )

          ],
        ),
      ),
    );
  }
}