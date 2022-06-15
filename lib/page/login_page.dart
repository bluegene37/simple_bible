import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simple_bible/page/settings_page.dart';

import '../main.dart';

const users = {
  'dribbble@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
};

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String> _authUser(LoginData data) {
    print('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(data.name)) {
        return 'User not exists';
      }
      if (users[data.name] != data.password) {
        return 'Password does not match';
      }
      return 'Success';
    });
  }

  Future<String> _recoverPassword(String name) {
    print('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
      return 'Success';
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      // title: 'Simple Bible',
      // logo: 'assets/images/ecorp-lightblue.png',
      onLogin: _authUser,
      // onSignup: _authUser,
      theme: LoginTheme(
          primaryColor: themeColors[colorSliderIdx.value],
          accentColor: themeColorShades[colorSliderIdx.value],
          errorColor: Colors.red,
          titleStyle: const TextStyle(
            color: Colors.greenAccent,
            fontFamily: 'Raleway',
            letterSpacing: 4,
          )
      ),

      loginProviders: <LoginProvider>[
        LoginProvider(
          icon: FontAwesomeIcons.google,
          label: 'Google',
          callback: () async {
            print('start google sign in');
            await Future.delayed(loginTime);
            print('stop google sign in');
            return null;
          },
        ),
        LoginProvider(
          icon: FontAwesomeIcons.facebookF,
          label: 'Facebook',
          callback: () async {
            print('start facebook sign in');
            await Future.delayed(loginTime);
            print('stop facebook sign in');
            return null;
          },
        ),
      ],
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const SettingsLocalPage(),
        ));
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}