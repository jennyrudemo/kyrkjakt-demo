/*
* Copyright (c) 2021 Fei Alm, Jessie Chow, Anna Wästling, David Styrbjörn, Jenny Rudemo
* This source code is licensed under the MIT-style license found in the
* LICENSE file in the root directory of this source tree.
*
* @author Jessie Chow
* @date 2021-05-25
*
* @summary 
* Medium sized button with text and icon
* 
* @structure: 
* Creates a medium sized button with text, icon and color that executes an onCall-function when pressed
*  
* Variables - string: text of the button
*           - icon: icon of the button
*           - color: color of the icon
*           - onPressed: function to execute when button is pressed
*/

import 'package:flutter/foundation.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

Widget mediumTextIconButton(String string, IconData icon, Color color,
    VoidCallback onPressed, BuildContext context) {
  return
      //Sets the appearance of the button
      ElevatedButton(
          style: ElevatedButton.styleFrom(primary: color),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: AutoSizeText(
                  string,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.button,
                  maxLines: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 3.0),
                child: Icon(
                  icon,
                  size: 24,
                ),
              )
            ],
          ), //Sets the text of the button to input
          //Action performed when button is pressed
          // onPressed: () => onPressed()),
          onPressed: () => onPressed());
}
