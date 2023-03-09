/*
* Copyright (c) 2021 Fei Alm, Jessie Chow, Anna Wästling, David Styrbjörn, Jenny Rudemo
* This source code is licensed under the MIT-style license found in the
* LICENSE file in the root directory of this source tree.
*
* @author Jenny Rudemo, with assistance from Fei Alm
* @date 2021-04-29
*
* @summary
* This file is a widget that checks what type of platform the user has, android/iOS.
* Every Ar-game are implemented in two different ways to be function for both iOS and android.
*
* @structure:
* Widget always checks what type of platform the player has, then returning correct game to player
*/

import 'package:flutter/material.dart';
import 'package:kyrkjakt/config/color_config.dart';
import 'package:kyrkjakt/screens/activities/find_treasure_chest_ios_screen.dart';
import 'package:kyrkjakt/screens/activities/light_candles_ios_screen.dart';
import 'package:kyrkjakt/screens/activities/light_candles_android_screen.dart';
import 'package:kyrkjakt/widgets/clue_widget.dart';
import 'package:kyrkjakt/widgets/home_button_widget.dart';
import 'package:kyrkjakt/widgets/round_icon_button.dart';
import 'package:provider/provider.dart';
import 'package:kyrkjakt/screens/activities/find_treasure_chest_android_screen.dart';
import 'package:kyrkjakt/models/activity_model.dart';
import 'package:kyrkjakt/widgets/medium_text_icon_button.dart';
import 'package:kyrkjakt/models/user_model.dart';
import 'dart:io' show Platform;

class ArActivityScreen extends StatefulWidget {
  //Define callback
  final VoidCallback winCallback;
  final VoidCallback skipCallback;

  //Constructor using callback
  ArActivityScreen(this.winCallback, this.skipCallback);

  @override
  _ArActivityScreenState createState() => _ArActivityScreenState();
}

class _ArActivityScreenState extends State<ArActivityScreen> {
  bool help = false;

  //Redirects to fact screen
  void getFactScreen() {
    Navigator.pushNamed(context, "/fact");
  }

  //Toggles help screen
  void toggleHelp() {
    setState(() {
      help = !help;
    });
  }

  Widget arView() {
    var activity = Provider.of<ActivityModel>(context, listen: false);
    if (Platform.isAndroid && activity.id == "light_candles_activity") {
      //Return ARCore widget
      return LightCandlesAndroid(widget.winCallback);
    } else if (Platform.isAndroid &&
        activity.id == "find_treasurechest_activity") {
      return FindTreasureAndroid(widget.winCallback);
    } else if (Platform.isIOS && activity.id == "light_candles_activity") {
      //Return ARKit widget
      return LightCandlesIOS(widget.winCallback);
    } else if (Platform.isIOS && activity.id == "find_treasurechest_activity") {
      return FindTreasureIOS(widget.winCallback);
    } else {
      print("Something went wrong checking platform for AR-games");
      return null;
    }
  }

// Holds the buttons home, info and help
  Widget topButtonSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.only(left: 15.0),
            alignment: Alignment.centerLeft,
            // home button
            child: goHomeButton(context),
          ),
        ),
        // info button
        roundIconButton(
          Icons.info_outline,
          Colors.orange,
          getFactScreen,
          context,
        ),
        //help button
        roundIconButton(
          Icons.help_outline,
          Colors.orange,
          toggleHelp,
          context,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Clue screen
    if (help) {
      return Clue(
          backdropColor: ColorConfig().darkPurple,
          goBackCallback: () {
            setState(() {
              help = false;
            });
          });
    }
    var user = Provider.of<UserModel>(context, listen: false);
    return Material(
      child: Scaffold(
        //Top bar with buttons
        appBar: PreferredSize(
          //Top section widget wrapped in container to be able to set color
          child: Container(
            child: topButtonSection(context),
            color: ColorConfig().darkPurple,
          ),
          preferredSize: new Size.fromHeight(80.0),
        ),
        //Getting the correct AR view
        body: arView(),
        //Bottom bar with skip button
        bottomNavigationBar: BottomAppBar(
          color: ColorConfig().darkPurple,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: FractionallySizedBox(
              //changes the size of the button
              widthFactor: 0.6,
              heightFactor: 0.1,
              child: mediumTextIconButton(
                  user.languageMap["skip"][user.language],
                  Icons.fast_forward,
                  Colors.orange,
                  widget.skipCallback,
                  context),
            ),
          ),
        ),
      ),
    );
  }
}
