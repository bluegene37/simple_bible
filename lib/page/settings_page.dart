import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_picker/flutter_font_picker.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
                activeSwitchColor: globalColor.value,
                onToggle: (value) {
                  value1.value = value;
                  if(value1.value){
                    // globalColor = Colors.blue;
                    globalTextColor.value = Colors.white;
                    globalSearchColor = Colors.amber;
                    globalHighLightColor = Colors.grey.shade700;
                    shadesList = [0xff303030,0xff303030,0xff303030,0xff424242,0xff424242,0xff616161,0xff616161,0xff757575,0xff757575];
                    AdaptiveTheme.of(context).setDark();
                  }else{
                    // globalColor = Colors.blue;
                    globalTextColor.value = Colors.black;
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
              // SettingsTile.switchTile(
              //   onToggle: (value) {
              //     value2.value = value;
              //   },
              //   initialValue: value2.value,
              //   // leading: const Icon(Icons.format_paint),
              //   title: const Text('Version: KJV/NIV'),
              // ),
              SettingsTile(
                title: Text('Font Size: '+  (fontSize.value + 15).toStringAsFixed(2)),
              ),
            ],
          ),
          CustomSettingsSection(
            child: Container(
              padding: const EdgeInsets.only(left: 20.0,right: 20.0),
              child: CupertinoSlider(
                min: 0.0,
                max: 15.0,
                value: fontSize.value,
                onChanged: (double newFontSize) {
                  fontSize.value = newFontSize;
                },
                // divisions: 10,
              ),
            ),
          ),
          CustomSettingsSection(
            child: SettingsTile(
              title: Text('Font: Oswald', style: GoogleFonts.getFont('Raleway' , fontSize: 20)) ,
            ),
          ),
          CustomSettingsSection(
            child: Container(
              padding: const EdgeInsets.only(left: 20.0,right: 20.0),
              // margin: const EdgeInsets.symmetric(vertical: 20.0),
              height: 130.0,
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                children: <Widget>[
                  Card( child : ListTile( title : Text('Raleway', style: GoogleFonts.getFont('Raleway' , fontSize: 20)))),
                  Card( child : ListTile( title : Text('Oswald ', style: GoogleFonts.getFont('Oswald', fontSize: 20)))),
                  Card( child : ListTile( title : Text('Slabo 27px', style: GoogleFonts.getFont('Slabo 27px', fontSize: 20)))),
                  Card( child : ListTile( title : Text('Lato', style: GoogleFonts.getFont('Lato', fontSize: 20)))),
                  Card( child : ListTile( title : Text('Quattrocento', style: GoogleFonts.getFont('Quattrocento', fontSize: 20)))),
                  Card( child : ListTile( title : Text('Merriweather', style: GoogleFonts.getFont('Merriweather', fontSize: 20)))),
                  Card( child : ListTile( title : Text('Lobster', style: GoogleFonts.getFont('Lobster', fontSize: 20)))),
                  Card( child : ListTile( title : Text('Open Sans', style: GoogleFonts.getFont('Open Sans', fontSize: 20)))),
                  Card( child : ListTile( title : Text('Roboto', style: GoogleFonts.getFont('Roboto', fontSize: 20)))),
                  Card( child : ListTile( title : Text('Inconsolata', style: GoogleFonts.getFont('Inconsolata', fontSize: 20)))),
                  Card( child : ListTile( title : Text('Indie Flower', style: GoogleFonts.getFont('Indie Flower', fontSize: 20)))),
                ],
              ),
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
          // const CustomSettingsSection(
          //   child: CircleColor(color: Colors.blue, circleSize: 40,),
          // ),
        ],
      ),
      ),
    ),
  );
}


Widget colorPicker(){
  return MaterialColorPicker(
      // allowShades: false,
    onColorChange: (Color color) {
        globalColor.value = color;
    },
    selectedColor: globalColor.value
  );
}

