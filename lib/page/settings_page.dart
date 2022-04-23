import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
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
              SettingsTile.switchTile(
                activeSwitchColor: globalColor,
                onToggle: (value) {
                  value1.value = value;
                  if(value1.value){
                    // globalColor = Colors.blue;
                    globalTextColor = Colors.white;
                    globalSearchColor = Colors.amber;
                    globalHighLightColor = Colors.grey.shade700;
                    shadesList = [0xff303030,0xff303030,0xff303030,0xff424242,0xff424242,0xff616161,0xff616161,0xff757575,0xff757575];
                    AdaptiveTheme.of(context).setDark();
                  }else{
                    // globalColor = Colors.blue;
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
              SettingsTile(
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
          CustomSettingsSection(
            child: SettingsTile(
              title: const Text('Font:'),
            ),
          ),
          CustomSettingsSection(
            child: SettingsTile(
                  title: const Text('Color Theme:'),
                ),
          ),
          CustomSettingsSection(
            child: Container(
              padding: const EdgeInsets.only(left: 20.0,right: 20.0),
              child: colorPicker(),
            ),
          ),
        ],
      ),
      ),
    ),
  );
}


Widget colorPicker(){
  return MaterialColorPicker(
    onColorChange: (Color color) {
      globalColor = color;
      },
    selectedColor: globalColor
  );
}

