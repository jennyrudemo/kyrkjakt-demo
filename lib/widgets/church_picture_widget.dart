/*
* Copyright (c) 2021 Fei Alm, Jessie Chow, Anna Wästling, David Styrbjörn, Jenny Rudemo
* This source code is licensed under the MIT-style license found in the
* LICENSE file in the root directory of this source tree.
*
* @author Anna Wästling
* @date 2021
* @summary
* Builds the top-section displayed in fact-screen, game progress-screen
*/

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kyrkjakt/widgets/home_button_widget.dart';

Widget getAppIcon() {
  return Transform.scale(
    scale: 0.5,
    child: Transform.translate(
      offset: Offset(0.0,
          256.0), // This number should be half the icon images size? It's a little unclear
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Image.asset("assets/images/temp_icon.png"),
      ),
    ),
  );
}

// Holds the church image and logo
Widget topHalf(context, Image input) {
  double x = 0.8;
  //gets the image from the database

  return Stack(
    alignment: Alignment.topCenter,
    children: [
      ClipRRect(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.elliptical(300, 170.0),
        ),
        // Create the container in which the top image will live
        child: Container(
          // These sizes seem a bit arbitary, as long as they are big enough to cover the area ( i think and hope )
          width: 1500 * 0.8,
          height: 1000 * 0.8,
          decoration: BoxDecoration(
            color: Colors.greenAccent,
          ),
          child: input,
        ),
      ),
      Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0, left: 5.0),
          child: goHomeButton(context),
        ),
        alignment: Alignment.topLeft,
      ),
    ],
  );
}
