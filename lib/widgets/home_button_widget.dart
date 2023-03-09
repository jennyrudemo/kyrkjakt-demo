/*
* Copyright (c) 2021 Fei Alm, Jessie Chow, Anna Wästling, David Styrbjörn, Jenny Rudemo
* This source code is licensed under the MIT-style license found in the
* LICENSE file in the root directory of this source tree.
*
* @author Fei Alm, Jessie Chow
* @date 2021-05-25
*
* @summary
* Button to go back to the home screen
*/

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kyrkjakt/config/color_config.dart';

//Used to make a round button with a specified icon "icon"
Widget goHomeButton(context) {
  return Container(
    decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
      BoxShadow(
        blurRadius: 4,
        offset: Offset(4, 2),
        color: Colors.black.withOpacity(0.35),
      ),
    ]),
    child: ElevatedButton(
      child: Icon(Icons.home, size: 40),
      style: ElevatedButton.styleFrom(
          primary: ColorConfig().darkBlue,
          shape: CircleBorder(),
          padding: EdgeInsets.symmetric(horizontal: 3, vertical: 3)),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
  );
}

//Used to make a round button with a specified icon "icon"
Widget goHomeButtonBig(context) {
  return Container(
    height: 80, //Sets the size of the button
    //Sets the appearance of the button
    decoration: BoxDecoration(
      color: ColorConfig().darkBlue, //Sets the color of the button
      shape: BoxShape.circle, //Sets the shape of the button
      boxShadow: [
        //Sets a shadow on the button
        BoxShadow(
          blurRadius: 4,
          offset: Offset(4, 2),
          color: Colors.black.withOpacity(0.5),
        ),
      ],
    ),
    child: IconButton(
      icon: Icon(
        Icons.home,
      ), //Sets the icon of the button to icon
      iconSize: 60, //Sets the size of the icon
      color: Colors.white, //Sets the color of the icon
      //Action when the button is pressed
      onPressed: () {
        Navigator.pop(context);
      },
    ),
  );
}
