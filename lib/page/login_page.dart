import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:simple_bible/page/profile_page.dart';

import '../main.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  Duration get loginTime => const Duration(milliseconds: 1000);

  Future<String> _authUser(LoginData data) {
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(data.name)) {
        return 'User not exists';
      }
      if (users[data.name] != data.password) {
        return 'Password does not match';
      }
      return '';
    });
  }

  Future<String?> _signupUser(SignupData data) {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<String> _recoverPassword(String name) {
    print('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
      return '';
    });
  }

  @override
  Widget build(BuildContext context) {

    Future.delayed(Duration.zero, () => {
      barTitle.value = 'Log In',
    });

    return FlutterLogin(
      // scrollable: true,
      // logo: const AssetImage('assets/app_logo.png'),
      onLogin: _authUser,
      onSignup: _signupUser,
      onRecoverPassword: _recoverPassword,
      messages: LoginMessages(
          recoverPasswordDescription: 'We will send your recovery link to this email account.'
      ),
      // loginProviders: <LoginProvider>[
      //   LoginProvider(
      //     icon: FontAwesomeIcons.google,
      //     label: 'Google',
      //     callback: () async {
      //       await Future.delayed(loginTime);
      //       return null;
      //     },
      //   ),
      //   LoginProvider(
      //     icon: FontAwesomeIcons.facebookF,
      //     label: 'Facebook',
      //     callback: () async {
      //       await Future.delayed(loginTime);
      //       return null;
      //     },
      //   ),
      // ],
      onSubmitAnimationCompleted: () {
        pages[0] = const ProfileScreen();
        barTitle.value = "Settings";
        box.put('loggedIn', true);
        loggedIn = true;
        // Navigator.of(context).pushReplacement(MaterialPageRoute(
        //   builder: (context) => const SettingsLocalPage(),
        // ));
      },
      theme: LoginTheme(
          primaryColor: themeColors[colorSliderIdx.value],
          accentColor: themeColorShades[colorSliderIdx.value],
          errorColor: Colors.red,
          pageColorLight: Colors.white,
          pageColorDark: themeColorShades[colorSliderIdx.value],
      ),
    );
  }
}