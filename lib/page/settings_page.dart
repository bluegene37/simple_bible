import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:settings_ui/settings_ui.dart';
import '../main.dart';

final ItemScrollController itemScrollController = ItemScrollController();

class SettingsLocalPage extends StatefulWidget {
  const SettingsLocalPage({Key? key}) : super(key: key);

  @override
  SettingsLocalPageState createState() => SettingsLocalPageState();
}

class SettingsLocalPageState extends State<SettingsLocalPage> {
  bool status = false;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Obx( () => SettingsList(
              sections: [
                SettingsSection(
                  // title: const Text('Setting', style: TextStyle(color: Colors.black,)),
                  tiles: <SettingsTile>[
                    SettingsTile.navigation(
                      // leading: const Icon(Icons.language),
                      title: const Text('Version:'),
                      value: Text(bibleVersions),
                      // trailing: const Text('KJV'),
                    ),
                    SettingsTile(
                      title: const Text('Text Preview:'),
                      value: Expanded(
                        child: Text(
                            'In the beginning God created the heaven and the earth. ',
                            style: GoogleFonts.getFont(globalFont.value,
                            fontSize: 15 + fontSize.value)
                          ),
                        ),
                      ),
                    SettingsTile(
                      title: Text('Font Size: ${(fontSize.value + 15).toStringAsFixed(2)}'),
                      value: CupertinoSlider(
                          min: 0.0,
                          max: 15.0,
                          value: fontSize.value,
                          onChanged: (double newFontSize) {
                            fontSize.value = newFontSize;
                            box.put('fontSize', newFontSize);
                          },
                          // divisions: 10,
                        ),
                    ),
                    SettingsTile(
                      title: const Text('Font:'),
                    ),
                  ],
                ),
                // CustomSettingsSection(
                //   child: Container(
                //     padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                //     child: CupertinoSlider(
                //       min: 0.0,
                //       max: 15.0,
                //       value: fontSize.value,
                //       onChanged: (double newFontSize) {
                //         fontSize.value = newFontSize;
                //         box.put('fontSize', newFontSize);
                //       },
                //       // divisions: 10,
                //     ),
                //   ),
                // ),
                // SettingsSection(
                //   tiles: <SettingsTile>[
                //     SettingsTile(
                //       // title: Text('Font: '+globalFont.value, style: GoogleFonts.getFont(globalFont.value , fontSize: 20)) ,
                //       // title: Text('Font: ${box.get('globalFont')}' + globalFont.value ),
                //       title: const Text('Font:'),
                //     ),
                //   ],
                // ),
                CustomSettingsSection(
                  child: Container(
                    padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                    child: fontPicker(),
                  ),
                ),
                SettingsSection(
                  tiles: <SettingsTile>[
                    SettingsTile(
                      title: const Text('Color Theme:'),
                    ),
                  ]
                ),
                CustomSettingsSection(
                  child: Container(
                    padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                    height: 45,
                    child: colorSlider(),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

Widget fontPicker(){
  CarouselController scrollCarouselController = CarouselController();
  return CarouselSlider(
    carouselController: scrollCarouselController,
    options: CarouselOptions(
      // aspectRatio: 4.0/9,
      height: 60,
      initialPage: globalFontIdx,
      enlargeCenterPage: true,
      enableInfiniteScroll: false,
      autoPlay: false,
      autoPlayInterval: const Duration(seconds: 2),
    ),
    items: fontLists.map((i) {
      return Builder(
        builder: (BuildContext context) {
          return Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 1.0),
            child: Obx(()=> Card(
              color: globalFont.value == i ? themeColorShades[colorSliderIdx.value] : null,
              child: InkWell(
                onTap: () {
                  globalFont.value = i;
                  box.put('globalFont', i);
                  globalFontIdx = fontLists.indexWhere((list) => list.contains(i));
                  box.put('globalFontIdx', fontLists.indexWhere((list) => list.contains(i)));
                },
                child: ListTile(
                    title: Text(i, style: GoogleFonts.getFont(i, fontSize: 20, ),textAlign: TextAlign.center )),
              ),
              ),
            ),
          );
        },
      );
    }).toList(),
  );

}

var fontLists = [
  'Inconsolata',
  'Indie Flower',
  'Lato',
  'Lobster',
  'Merriweather',
  'Open Sans',
  'Oswald',
  'Quattrocento',
  'Raleway',
  'Roboto',
  'Slabo 27px',
];


Widget colorSlider(){
  return  ScrollablePositionedList.separated(
    scrollDirection: Axis.horizontal,
    itemCount: themeColors.length,
    separatorBuilder: (context, index){
      return const SizedBox(width: 5);
    },
    itemBuilder: (context, index){
      if(!statusBarChanged){
        Future.delayed(Duration.zero, () => {
          itemScrollController.jumpTo(index: colorSliderIdx.value),
          statusBarChanged = true
        });
      }
      return  InkWell(
        child: Obx(() =>CircleAvatar(
          radius: 50 / 2,
          backgroundColor: themeColors[index],
          child: colorSliderIdx.value == index ? Icon(Icons.check, color: textColorDynamic.value) : null,
          ),
        ),
        onTap: (){
          onchangeColor(index);
          checkColorBrightness();
            if(index == 0){
              AdaptiveTheme.of(context).setLight();
              onchangeTextColor(1);
            }else if(index == 1){
              AdaptiveTheme.of(context).setDark();
              onchangeTextColor(0);
            }else{
              AdaptiveTheme.of(context).setLight();
              onchangeTextColor(1);
            }
        },
      );
    },
    itemScrollController: itemScrollController,
  );
}

onchangeColor(idx){
  colorSliderIdx.value = idx;
  box.put('colorSliderIdx', idx);
}

onchangeTextColor(idx){
  textColorIdx.value = idx;
  box.put('textColorIdx', idx);
}

checkColorBrightness(){
  brightness = ThemeData.estimateBrightnessForColor(themeColors[colorSliderIdx.value]);
  textColorDynamic.value = brightness == Brightness.light ? Colors.black : Colors.white;
}