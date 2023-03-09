/*
* Copyright (c) 2021 Fei Alm, Jessie Chow, Anna Wästling, David Styrbjörn, Jenny Rudemo
* This source code is licensed under the MIT-style license found in the
* LICENSE file in the root directory of this source tree.
*
* @author Kyrkjakten
* @date 2021
*
* @summary
* Shows the number of activities that has been completed
*
* @structure
*/

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kyrkjakt/config/color_config.dart';
import 'package:kyrkjakt/models/church_model.dart';
import 'package:kyrkjakt/models/user_model.dart';
import 'package:kyrkjakt/widgets/church_picture_widget.dart';
import 'package:kyrkjakt/widgets/text_to_speech_button_widget.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class GameProgress extends StatefulWidget {
  @override
  _GameProgressState createState() => _GameProgressState();
}

class _GameProgressState extends State<GameProgress> {
  // Declare the states, set total to -1 since we don't wanna divide by 0 (in any case)
  int numberOfCompletedActivities = 0;
  int totalNumberOfActivities = -1;
  double completionRatio = 0.0;
  Image image;

  // @override
  void initState() {
    getImage();
    super.initState();
  }

//get image from database
  void getImage() async {
    var church = Provider.of<ChurchModel>(context, listen: false);
    String imageURL = await firebase_storage.FirebaseStorage.instance
        .ref(church.coverImageUrl)
        .getDownloadURL();

    //notifies that image has changed
    setState(() {
      image = Image.network(imageURL, fit: BoxFit.cover);
    });
  }

  String getDynamicText() {
    var user = Provider.of<UserModel>(context, listen: false);
    // By default we assume the user has completed all activities, check for otherwise
    // The dynamicText varies depending on how many activities the user has completed
    String dynamicText = user.languageMap["progress_text4"][user.language];

    // Levels: 0.0 to 0.5 -> 0.5 to 1.0 -> 1.0
    // Go through and check each level.
    if (completionRatio <= 0) {
      dynamicText = user.languageMap["progress_text1"][user.language];
    } else if (completionRatio > 0 && completionRatio < 0.5) {
      dynamicText = user.languageMap["progress_text2"][user.language];
    } else if (completionRatio >= 0.5 && completionRatio < 1.0) {
      dynamicText = user.languageMap["progress_text3"][user.language];
    }

    return dynamicText;
  }

  //Used to display the trophy
  Widget imageSection() {
    Size phoneSize = MediaQuery.of(context).size;

    const double niceHeightFactor = 830.0; //720
    double imageScale = phoneSize.height / niceHeightFactor;

    // Conditional rendering
    Widget returnWidget = phoneSize.height > 500
        ? Container(
            child: Image.asset(
              "assets/images/icons/reward_icon.png",
              width: 85 * imageScale,
            ),
          )
        : null;

    return returnWidget;
  }

  // Used in build(), creates the most important part of the progress screen!
  Widget body() {
    String display = numberOfCompletedActivities.toString() +
        "/" +
        totalNumberOfActivities.toString();

    String dynamicText = getDynamicText();
    var user = Provider.of<UserModel>(context, listen: false);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextToSpeechButton(
          readUp: dynamicText,
        ),
        Expanded(
          flex: 1,
          child: AutoSizeText(
            user.languageMap["progress_screen_title"]
                [user.language], //Sets the title with input
            textAlign: TextAlign.center,
            minFontSize: 35,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        //Space for progressbar
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(
                right: 32.0, left: 32.0, top: 5.0, bottom: 5.0),
            child: LiquidLinearProgressIndicator(
              value: completionRatio,
              valueColor:
                  AlwaysStoppedAnimation(ColorConfig().progressBarForeground),
              backgroundColor: ColorConfig().progressBarBackground,
              borderColor: Colors.transparent,
              borderWidth: 5.0,
              borderRadius: 12.0,
            ),
          ),
        ),
        AutoSizeText(display, style: Theme.of(context).textTheme.headline2),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 15.0),
            child: imageSection(),
          ),
        )
      ],
    );
  }

  Widget bottomTextSection() {
    String dynamicText = getDynamicText();

    return Padding(
      padding: const EdgeInsets.only(left: 32.0, right: 32.0, top: 30.0),
      child: AutoSizeText(
        dynamicText,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline3,
        maxLines: 5,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get some states we pass down to all the widgets
    ChurchModel church = Provider.of<ChurchModel>(context, listen: false);
    UserModel user = Provider.of<UserModel>(context, listen: false);

    // Check here, otherwise we get into a recursion loop
    if (totalNumberOfActivities == -1) {
      setState(() {
        totalNumberOfActivities = church.activityList.length;
        numberOfCompletedActivities =
            user.getCompletedActivites(church.name).length;
        completionRatio = numberOfCompletedActivities.toDouble() /
            totalNumberOfActivities.toDouble();
      });
    }

    return Material(
      child: Container(
        decoration: new BoxDecoration(color: ColorConfig().gameProgress),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: topHalf(context, image),
            ),
            Expanded(
              flex: 5,
              child: body(),
            ),
            Expanded(
              flex: 3,
              child: bottomTextSection(),
            )
          ],
        ),
      ),
    );
  }
}
