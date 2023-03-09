/*
* Copyright (c) 2021 Fei Alm, Jessie Chow, Anna Wästling, David Styrbjörn, Jenny Rudemo
* This source code is licensed under the MIT-style license found in the
* LICENSE file in the root directory of this source tree.
*
* @author Jessie Chow, Fei Alm
* @date 2021-05-25
* @summary 
* Round button with icon
*
* @structure: 
* Creates a round button with icon and color that executes an onCall-function when pressed   
*
* Variables  - icon: icon of the button
*            - color: color of the icon
*            - onPressed: function to execute when button is pressed
*/

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget roundIconButton(
    IconData icon, Color color, VoidCallback onPressed, BuildContext context) {
  return Container(
    decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
      BoxShadow(
        blurRadius: 4,
        offset: Offset(4, 2),
        color: Colors.black.withOpacity(0.35),
      ),
    ]),
    child: ElevatedButton(
      child: Icon(icon, size: 40),
      style: ElevatedButton.styleFrom(
          primary: color,
          shape: CircleBorder(),
          padding: EdgeInsets.symmetric(horizontal: 3, vertical: 3)),
      onPressed: () => onPressed(),
    ),
  );
}
