/*
* Copyright (c) 2021 Fei Alm, Jessie Chow, Anna Wästling, David Styrbjörn, Jenny Rudemo
* This source code is licensed under the MIT-style license found in the
* LICENSE file in the root directory of this source tree.
*
* @author David Styrbjörn
* @date 2021-04-26
*
* @summary
* Displays clues on how to complete the activity
*
* @structure
* Gets data from the database and displays it
*/

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:kyrkjakt/models/activity_model.dart';
import 'package:kyrkjakt/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:kyrkjakt/widgets/text_to_speech_button_widget.dart';
import 'package:kyrkjakt/widgets/round_icon_button.dart';

class Clue extends StatefulWidget {
  @override
  _ClueState createState() => _ClueState();

  final Color backdropColor;
  final VoidCallback goBackCallback;

  Clue({this.backdropColor, this.goBackCallback});
}

class _ClueState extends State<Clue> {
  // Builds the popup widget
  Widget popupScreen() {
    //Handles the animation of the scroll
    double scrollScale = 1.0;
    return Center(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/scroll.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: FractionallySizedBox(
          widthFactor: 0.9 * scrollScale,
          heightFactor: 0.8 * scrollScale,
          child: getClueContent(),
        ),
      ),
    );
  }

  String getClueLiteral(ActivityModel activityModel, UserModel user) {
    return activityModel.isEasy
        ? activityModel.clueEasy[user.language]
        : activityModel.clue[user.language];
  }

  Widget getClueContent() {
    var user = Provider.of<UserModel>(context, listen: false);
    return Consumer<ActivityModel>(builder: (context, activity, child) {
      return FractionallySizedBox(
        widthFactor: 0.85,
        child: Column(
          children: [
            Spacer(flex: 1), // The padding on top
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: AutoSizeText(
                      user.languageMap["clue"][user.language],
                      style: Theme.of(context).textTheme.headline2,
                      maxLines: 1,
                    ),
                  ),
                  TextToSpeechButton(
                    readUp: getClueLiteral(activity, user),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, top: 15.0, bottom: 15.0),
                    child: AutoSizeText(getClueLiteral(activity, user),
                        style: Theme.of(context).textTheme.bodyText1,
                        //maxLines: 5,
                        textAlign: TextAlign.center,
                        minFontSize: 12,
                        maxFontSize: 15,
                        maxLines: 7),
                  ),
                  Spacer(),
                  // Close Clue-screen button
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        roundIconButton(Icons.close, Colors.orange,
                            widget.goBackCallback, context),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: AutoSizeText(
                            user.languageMap["back"][user.language],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'FoundrySterling',
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backdropColor,
      child: popupScreen(),
    );
  }
}
