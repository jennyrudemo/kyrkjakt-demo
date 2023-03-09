/*
* Copyright (c) 2021 Fei Alm, Jessie Chow, Anna Wästling, David Styrbjörn, Jenny Rudemo
* This source code is licensed under the MIT-style license found in the
* LICENSE file in the root directory of this source tree.
*
* @author Kyrkjakten
* @date 2021
*
* @summary
* The big yellow button, used several times whithin the app
*
* @structure
* Creates a button with text and executes an onCall-function when pressed
*
* Variables - text: text of the button
            - onPressed: function to execute when the button is pressed
*/

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Widget getBigButton(String text, VoidCallback onPressed, BuildContext context) {
  return Container(
    // Makes it the correct color and puts a shadow on the button
    child: ElevatedButton(
      child: AutoSizeText(
        text,
        style: Theme.of(context).textTheme.button,
        maxLines: 1,
        minFontSize: 10,
        maxFontSize: 18,
      ),
      onPressed: () {
        onPressed();
      },
    ),
  );
}
