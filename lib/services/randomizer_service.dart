/*
* Copyright (c) 2021 Fei Alm, Jessie Chow, Anna Wästling, David Styrbjörn, Jenny Rudemo
* This source code is licensed under the MIT-style license found in the
* LICENSE file in the root directory of this source tree.
*
* @author Fei Alm, Jenny Rudemo
* @date 2021-04-29
*
* @summary 
*  Contains a randomizer function reused in multiple widgets  
*/

import 'dart:math';

// generates a random positioning in vectorspace
randomizer(var val) {
  final randomNumberGenerator = Random();
  final randomBoolean =
      randomNumberGenerator.nextBool(); // generates random false or true

  // determinate if value should be negative or positive
  if (randomBoolean == true) {
    val = val * (-1);
  }
  return val;
}
