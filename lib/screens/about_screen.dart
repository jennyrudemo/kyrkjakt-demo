/*
* Copyright (c) 2021 Fei Alm, Jessie Chow, Anna Wästling, David Styrbjörn, Jenny Rudemo
* This source code is licensed under the MIT-style license found in the
* LICENSE file in the root directory of this source tree.
*
* @author Anna Wästling
* @date 2021-05-25
*
* @summary
* Background about the app and the developers
*/

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:kyrkjakt/config/color_config.dart';
import 'package:kyrkjakt/widgets/back_button.dart';
import 'package:kyrkjakt/widgets/text_to_speech_button_widget.dart';
import 'package:kyrkjakt/models/user_model.dart';
import 'package:provider/provider.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    //define a user for language purposes
    var user = Provider.of<UserModel>(context, listen: false);
    //define the screens heigth and width
    var screenHeight = (MediaQuery.of(context).size.height);
    var screenWidth = (MediaQuery.of(context).size.width);
    const double niceWidthFactor = 360.0;
    double scaleWidth = screenWidth / niceWidthFactor;

    //prevents oversized text
    var maxFont;
    user.language == 0 ? maxFont = 26 : maxFont = 23;

    return Material(
      child: Container(
        color: ColorConfig().lightGreen,
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              // back-button and title
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  goBackButton(context),
                  //space between backbutton and title
                  SizedBox(width: screenWidth * 0.06 * scaleWidth),
                  AutoSizeText(
                    user.languageMap["about"][user.language],
                    style: Theme.of(context).textTheme.headline2,
                    maxFontSize: maxFont.toDouble(),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 5,
              // text and the tts button
              child: Container(
                decoration: BoxDecoration(
                    color: ColorConfig().darkGreen,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                //to make the container not go all the way out in the sides
                width: screenWidth * 0.9,
                //alignment for text
                alignment: Alignment.center,
                //padding for text
                padding: EdgeInsets.all(screenWidth * 0.05),
                child: Column(
                  children: [
                    //holds the tts button, used to make space between button and text
                    SizedBox(
                      height: screenHeight * 0.1,
                      child: TextToSpeechButton(
                        readUp: user.languageMap["about_content"]
                            [user.language],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: AutoSizeText(
                        user.languageMap["about_content"][user.language],
                        style: Theme.of(context).textTheme.bodyText1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
