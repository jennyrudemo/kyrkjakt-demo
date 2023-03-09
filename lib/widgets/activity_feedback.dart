/*
* Copyright (c) 2021 Fei Alm, Jessie Chow, Anna Wästling, David Styrbjörn, Jenny Rudemo
* This source code is licensed under the MIT-style license found in the
* LICENSE file in the root directory of this source tree.
*
* @author Jenny Rudemo
* @date 2021
* @summary
* @structure
*/

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:kyrkjakt/config/color_config.dart';
import 'package:kyrkjakt/models/user_model.dart';
import 'package:kyrkjakt/widgets/home_button_widget.dart';
import 'package:kyrkjakt/widgets/text_to_speech_button_widget.dart';
import 'package:kyrkjakt/widgets/yellow_button_widget.dart';
import 'package:provider/provider.dart';

//Shown if an AR activity is not available
//Presents the user with two options: go to the next activity or change the
//settings for camera permission
Widget activityNotAvailable(
    VoidCallback onActivitySkipped, UserModel user, BuildContext context) {
  String text =
      user.languageMap["activity_not_available_description"][user.language];

  return Material(
    color: ColorConfig().darkPurple,
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /* Text to speech button */
          TextToSpeechButton(
            readUp: text,
          ),
          SizedBox(height: 15), //Add spacing between children
          /* Info text */
          AutoSizeText(
            text,
            style: Theme.of(context).textTheme.bodyText1,
            minFontSize: 12,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20), //Add spacing between children
          /* Button go to next activity */
          getBigButton(user.languageMap["next_activity"][user.language],
              onActivitySkipped, context),
        ],
      ),
    ),
  );
}

//Widget when all activities are completed
Widget allActivitiesCompleted(BuildContext context) {
  var user = Provider.of<UserModel>(context, listen: false);
  return FractionallySizedBox(
    widthFactor: 0.85,
    child: Column(
      children: [
        Spacer(flex: 1), // The padding on top
        Expanded(
          flex: 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: AutoSizeText(
                  user.languageMap["all_activities_completed"][user.language],
                  style: TextStyle(fontSize: 30),
                  maxLines: 2,
                  maxFontSize: 30,
                  textAlign: TextAlign.center,
                ),
              ),
              Spacer(),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Spacer(),
                    // Home button
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        goHomeButtonBig(context),
                        AutoSizeText(
                          user.languageMap["home"][user.language],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'FoundrySterling',
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    //Rewardbutton
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        goToRewardsButton(context),
                        AutoSizeText(
                          user.languageMap["progress_button_title"]
                              [user.language],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'FoundrySterling',
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ],
          ),
        ),
        Spacer(flex: 1), // Bottom padding same method as the top padding
      ],
    ),
  );
}

//reward button
Widget goToRewardsButton(context) {
  return InkWell(
    child: Container(
      height: 80,
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          color: ColorConfig().orangeButton,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              offset: Offset(4, 2),
              color: Colors.black.withOpacity(0.5),
            ),
          ]),
      child: Image.asset(
        "assets/images/icons/completedgames.png",
        width: 50,
        height: 50,
      ),
      // The title text
    ),
    onTap: () {
      Navigator.pushNamed(context, "/game_progress_screen");
    },
  );
}
