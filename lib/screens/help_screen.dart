/*
* Copyright (c) 2021 Fei Alm, Jessie Chow, Anna Wästling, David Styrbjörn, Jenny Rudemo
* This source code is licensed under the MIT-style license found in the
* LICENSE file in the root directory of this source tree.
*
* @author Anna Wästling
* @date 2021-05-25
*
* @summary
* Instructions on how to use the app
*/

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:kyrkjakt/config/color_config.dart';
import 'package:kyrkjakt/widgets/home_button_widget.dart';
import 'package:kyrkjakt/widgets/text_to_speech_button_widget.dart';
import 'package:kyrkjakt/models/user_model.dart';
import 'package:provider/provider.dart';

class HelpScreen extends StatefulWidget {
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  @override
  Widget build(BuildContext context) {
    //define a user for language purposes
    var user = Provider.of<UserModel>(context, listen: false);
    //define the screens heigth and width
    var screenHeight = (MediaQuery.of(context).size.height);
    var screenWidth = (MediaQuery.of(context).size.width);
    const double niceWidthFactor = 360.0;
    double scaleWidth = screenWidth / niceWidthFactor;

    return Material(
      child: Container(
        color: ColorConfig().lightGreen,
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              // home-button and the title
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  goHomeButton(context),
                  //space between home-button and title
                  SizedBox(
                    width: screenWidth * 0.22 * scaleWidth,
                  ),
                  AutoSizeText(
                    user.languageMap["help"][user.language],
                    style: Theme.of(context).textTheme.headline2,
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
            Expanded(
              flex: 6,
              //darkgreen container that holds the text and the tts button
              child: Container(
                  decoration: BoxDecoration(
                      color: ColorConfig().darkGreen,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  //to make the darkgreen not go all the way out in the sides
                  width: (MediaQuery.of(context).size.width) * 0.9,
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
                          readUp: user.languageMap["help_content"]
                              [user.language],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: AutoSizeText(
                          user.languageMap["help_content"][user.language],
                          style: Theme.of(context).textTheme.bodyText1,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )),
            ),
            Expanded(
              flex: 1,
              //container that holds the "about Kyrkjakten" button
              child: Container(
                  padding: EdgeInsets.only(
                      //padding
                      top: screenHeight * 0.03,
                      bottom: screenHeight * 0.03),
                  // to get right width of the button
                  child: ConstrainedBox(
                      constraints:
                          BoxConstraints.tightFor(width: screenWidth * 0.6),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: ColorConfig().orangeButton,
                        ),
                        child: AutoSizeText(
                            user.languageMap["about"][user.language],
                            style: Theme.of(context).textTheme.button),
                        onPressed: () {
                          Navigator.pushNamed(context, "/about_screen");
                        },
                      ))),
            ),
          ],
        ),
      ),
    );
  }
}
