import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:settings_ui/settings_ui.dart';

import '../main.dart';

var value1 = false.obs;
var value2 = false.obs;
var value3 = false.obs;
var value4 = false.obs;

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
      child: Obx(() =>  SettingsList(
        sections: [
          SettingsSection(
            // title: const Text('Common'),
            tiles: <SettingsTile>[
              // SettingsTile.navigation(
              //   leading: const Icon(Icons.language),
              //   title: const Text('Language'),
              //   value: const Text('English'),
              // ),
              SettingsTile.switchTile(
                onToggle: (value) {
                  value1.value = value;
                  if(value1.value){
                    globalColor = Colors.grey.shade800;
                    globalTextColor = Colors.white;
                    globalSearchColor = Colors.amber;
                    globalHighLightColor = Colors.grey.shade700;
                    shadesList = [0xff303030,0xff303030,0xff303030,0xff424242,0xff424242,0xff616161,0xff616161,0xff757575,0xff757575];
                    AdaptiveTheme.of(context).setDark();
                  }else{
                    globalColor = Colors.grey.shade300;
                    globalTextColor = Colors.black;
                    globalSearchColor = Colors.red;
                    globalHighLightColor = Colors.yellow.shade200;
                    shadesList = [0xfffafafa,0xfffffde7,0xfffff9c4,0xfffff59d,0xfffff176,0xffffee58,0xffffeb3b,0xfffdd835,0xfffbc02d];
                    AdaptiveTheme.of(context).setLight();
                  }
                },
                initialValue: value1.value,
                // leading: const Icon(Icons.format_paint),
                title: const Text('Theme: Light/Dark'),
              ),
              SettingsTile.switchTile(
                onToggle: (value) {
                  value2.value = value;
                },
                initialValue: value2.value,
                // leading: const Icon(Icons.format_paint),
                title: const Text('Version: KJV/NIV'),
              ),
              SettingsTile.navigation(
                // leading: Icon(Icons.language),
                title: Text('Font: '),
                value: const Text('English'),
              ),
              // SettingsTile.switchTile(
              //   onToggle: (value) {
              //     value3.value = value;
              //   },
              //   initialValue: value3.value,
              //   // leading: const Icon(Icons.format_paint),
              //   title: const Text('Font: '),
              // ),
              SettingsTile.switchTile(
                onToggle: (value) {
                  value4.value = value;
                },
                initialValue: value4.value,
                // leading: const Icon(Icons.format_paint),
                title: Text('Font Size: '+fontSize.value.toString()),
              ),
            ],
          ),
          CustomSettingsSection(
            child: Slider.adaptive(
              min: 0.0,
              max: 4.0,
              value: fontSize.value,
              onChanged: (newFontSize) {
                fontSize.value = newFontSize;
              },
              divisions: 4,
            ),
          ),
        ],
      ),
      ),
    ),
  );
}

