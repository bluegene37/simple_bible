import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';


class SettingsLocalPage extends StatefulWidget {
  const SettingsLocalPage({Key? key}) : super(key: key);

  @override
  _SettingsLocalPageState createState() => _SettingsLocalPageState();
  }

  class _SettingsLocalPageState extends State<SettingsLocalPage> {
  bool status = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: FlutterSwitch(
        width: 125.0,
        height: 55.0,
        valueFontSize: 25.0,
        toggleSize: 45.0,
        value: status,
        borderRadius: 30.0,
        padding: 8.0,
        showOnOff: true,
        onToggle: (val) {
          setState(() {
            status = val;
          });
        },
      ),
    ),
  );
}