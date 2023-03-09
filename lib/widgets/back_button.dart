/*
* Copyright (c) 2021 Fei Alm, Jessie Chow, Anna Wästling, David Styrbjörn, Jenny Rudemo
* This source code is licensed under the MIT-style license found in the
* LICENSE file in the root directory of this source tree.
*
* @author Fei Alm, Jessie Chow
* @date 2021-05-25
*
* @summary
* Button to go back to previous page
*/

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

//duplicate of home_button_widget but with a different icon
Widget goBackButton(context) {
  return Container(
    decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
      BoxShadow(
        blurRadius: 4,
        offset: Offset(4, 2),
        color: Colors.black.withOpacity(0.35),
      ),
    ]),
    child: ElevatedButton(
      child: Icon(Icons.arrow_back, size: 40),
      style: ElevatedButton.styleFrom(
          primary: Colors.orange,
          shape: CircleBorder(),
          padding: EdgeInsets.symmetric(horizontal: 3, vertical: 3)),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
  );
}
