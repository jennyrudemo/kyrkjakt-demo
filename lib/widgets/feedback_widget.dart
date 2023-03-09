/*
* Copyright (c) 2021 Fei Alm, Jessie Chow, Anna Wästling, David Styrbjörn, Jenny Rudemo
* This source code is licensed under the MIT-style license found in the
* LICENSE file in the root directory of this source tree.
*
* @author Anna Wästling
* @date 2021
*
* @summary
* Gives the user feedback that the answer was incorrect
*/

import 'package:flutter/material.dart';
import 'package:kyrkjakt/config/color_config.dart';
import 'package:kyrkjakt/models/user_model.dart';
import 'package:provider/provider.dart';
import 'text_to_speech_button_widget.dart';

// Feedback for user when wrong answer is submitted
Widget buildPopupDialog(BuildContext context) {
  var user = Provider.of<UserModel>(context, listen: false);
  return new AlertDialog(
    shape: RoundedRectangleBorder(),
    backgroundColor: ColorConfig().darkPurple,
    title: Text(user.languageMap["wrong_answer_feedback_title"][user.language],
        style: Theme.of(context).textTheme.headline3),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        TextToSpeechButton(
          readUp: user.languageMap["wrong_answer_feedback_description"]
              [user.language],
        ),
        SizedBox(height: 10),
        Text(
          user.languageMap["wrong_answer_feedback_description"][user.language],
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ],
    ),
    // Close button
    actions: <Widget>[
      new ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5)),
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text('Stäng', style: Theme.of(context).textTheme.button),
      ),
    ],
  );
}
