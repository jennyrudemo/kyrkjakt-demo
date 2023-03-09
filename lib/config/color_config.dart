/*
* Copyright (c) 2021 Fei Alm, Jessie Chow, Anna Wästling, David Styrbjörn, Jenny Rudemo
* This source code is licensed under the MIT-style license found in the
* LICENSE file in the root directory of this source tree.
*
* @author Anna Wästling
* @date 2021-03-16
*
* @summary 
* This file contains coded themes such as color and fonts that can be used when implement other
* functionalities into the app Kyrkjakten
*/

import 'package:flutter/material.dart';

class ColorConfig {
  // Creates an object the the private constructor
  static final ColorConfig _instance = ColorConfig._internal();

  // Default constructors returns our ONLY instance of this class
  factory ColorConfig() => _instance;

  // Private constructor
  ColorConfig._internal();

  // colors from the graphic profile of Svenska kyrkan
  Color darkBlue = Color.fromRGBO(0, 111, 185, 1.0);
  Color lightBlue = Color.fromRGBO(190, 226, 233, 1.0);
  Color darkPurple = Color.fromRGBO(82, 37, 131, 1.0);
  Color orangeButton = Color.fromRGBO(245, 156, 0, 1.0);
  Color grayButton = Color.fromRGBO(150, 150, 150, 1.0);
  Color activityScreenBigButton = Color.fromRGBO(245, 156, 0, 1.0);
  Color gameProgress = Color.fromRGBO(144, 25, 19, 1.0);
  Color textColor = Colors.white;
  Color darkPink = Color.fromRGBO(167, 22, 128, 1.0);
  Color darkGreen = Color.fromRGBO(74, 106, 33, 1.0);
  Color lightGreen = Color.fromRGBO(107, 149, 49, 1.0);
  Color verylightGreen = Color.fromRGBO(175, 202, 11, 1.0);
  Color progressBarForeground = Color.fromRGBO(253, 194, 2, 1.0);
  Color progressBarBackground = Color.fromRGBO(213, 22, 27, 1.0);

  // Menu colors
  Color homeScreenActivityButton = Color.fromRGBO(82, 37, 131, 1.0);
  Color homeScreenRewardsButton = Color.fromRGBO(145, 22, 15, 1.0);
  Color homeScreenSettingsButton = Color.fromRGBO(74, 106, 33, 1.0);
}
