/*
* Copyright (c) 2021 Fei Alm, Jessie Chow, Anna Wästling, David Styrbjörn, Jenny Rudemo
* This source code is licensed under the MIT-style license found in the
* LICENSE file in the root directory of this source tree.
*
* @author Fei Alm
* @date 2021
*
* @summary
* Button to continue to next page, used the post activity screen
*/

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kyrkjakt/config/color_config.dart';

Widget getContinueButton(VoidCallback onPressed, BuildContext context) {
  return Container(
    height: 65,
    decoration: BoxDecoration(
        color: ColorConfig().orangeButton,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            offset: Offset(4, 2),
            color: Colors.black.withOpacity(0.35),
          ),
        ]),
    child: IconButton(
      padding: EdgeInsets.all(0.0),
      icon: Icon(
        Icons.arrow_right_alt,
      ), //Sets the icon of the button to icon
      iconSize: 40, //Sets the size of the icon
      color: Colors.white, //Sets the color of the icon
      //Action when the button is pressed
      onPressed: () {
        onPressed();
      },
    ),
  );
}
