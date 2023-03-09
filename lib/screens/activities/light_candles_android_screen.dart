/*
* Copyright (c) 2021 Fei Alm, Jessie Chow, Anna Wästling, David Styrbjörn, Jenny Rudemo
* This source code is licensed under the MIT-style license found in the
* LICENSE file in the root directory of this source tree.
*
* @author Fei Alm, Jenny Rudemo
* @date 2021-04-29
*
* @summary 
* Code for AR-game "Tända ljus" on android-platform
*
* @structure: 
*/

import 'dart:ui';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:kyrkjakt/models/activity_model.dart';
import 'package:kyrkjakt/services/randomizer_service.dart';
import 'package:provider/provider.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class LightCandlesAndroid extends StatefulWidget {
  @override
  _LightCandlesAndroidState createState() => _LightCandlesAndroidState();

  //Define callback
  final VoidCallback winCallback;
  //Constructor using callback
  LightCandlesAndroid(this.winCallback);
}

class _LightCandlesAndroidState extends State<LightCandlesAndroid> {
  ArCoreController arCoreController;
  ArCoreCylinder candle; //Declares candle
  ArCoreSphere flame; //Declares flame
  List<ArCoreNode> flames = [];
  List<ArCoreNode> candleBases = [];
  ArCoreMaterial flameLit;
  ArCoreMaterial flameDead;
  int counter = 0;
  //numberOfCandles needs to be a static member to be used in the initializer
  //of tapped
  static int numberOfCandles = 0; //Initialize number of candles
  var zPos;
  var xPos;
  var spacing;

  //Set number of candles depending of the difficulty level
  void initState() {
    var activity = Provider.of<ActivityModel>(context, listen: false);

    if (activity.isEasy) {
      //Number of candles for easier difficulty
      numberOfCandles = 5;
      zPos = randomizer(3.0);
      xPos = randomizer(1.6);
      spacing = 1.0;
    } else {
      //Number of candles for harder difficulty
      numberOfCandles = 10;
      zPos = randomizer(3.7);
      xPos = randomizer(2.4);
      spacing = 1.5;
    }

    super.initState();
  }

  List<bool> tapped = List<bool>.filled(numberOfCandles, false);

  @override
  void dispose() {
    arCoreController?.dispose();
    super.dispose();
  }

  //Builds the AR layout and window
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ArCoreView(
        enableTapRecognizer: true, //Enables tapping
        onArCoreViewCreated: onArCoreViewCreated, //Includes AR view
      ),
    );
  }

  //Sets up the AR view
  void onArCoreViewCreated(ArCoreController arCoreController) {
    this.arCoreController = arCoreController;
    this.arCoreController.onNodeTap = (name) => onTapHandler(name);

    //Defines a high and low value for y, which are toggled between when
    //creating the candles
    var heightY = randomizer(0.5);
    final yHigh = heightY;
    final yLow = -2.0; //-2.5;

    //Defines x, y, and z coordinates for the candles
    var yPosBase = yLow;

    //Defines candle material
    final candleMaterial = ArCoreMaterial(
      color: Colors.white,
    );

    //Defines material for non-lit flame
    flameDead = ArCoreMaterial(color: Color(0x00000000));

    //Defines material for lit flame
    flameLit = ArCoreMaterial(color: Colors.orange[900]);

    for (var i = 0; i < numberOfCandles; i++) {
      //Both geometries needs to be declared within the loop to get individual
      // geometries that can be changes individually
      //Defines candle geometry
      candle = ArCoreCylinder(
        materials: [candleMaterial],
        radius: 0.6,
        height: 0.2,
      );

      //Defines flame
      flame = ArCoreSphere(
        materials: [flameDead],
        radius: 0.1,
      );

      //Toggles between a high and low y position to get the candles more
      //spread out
      // if yPosBase == yLow change to yHigh and vice versa
      yPosBase = yPosBase == yLow ? yHigh : yLow;

      //Adds candle geometry to node
      final baseNode = ArCoreNode(
        //Name just number to be able to use as index for list flames
        name: '$i',
        shape: candle,
        position: vector.Vector3(xPos, yPosBase, zPos * 3),
        //pos (0,0,0) is the phone's position
      );

      //Computes the y position for the flame
      var yPosFlame;
      if (yPosBase == yLow) {
        yPosFlame = yPosBase + candle.height + (flame.radius / 2) + 0.45;
      } else if (yPosBase == yHigh) {
        yPosFlame = yPosBase + candle.height + (flame.radius / 2) + 0.14;
      }

      //Adds the flame geometry to node
      final flameNode = ArCoreNode(
        //add i to differentiate the different nodes
        //makes it possible to light up all candles and not just one
        name: 'flame' + '$i',
        shape: flame,
        position: vector.Vector3(xPos, yPosFlame * 1.2, zPos * 3),
      );

      //Add flame and candle base nodes to list of flames and candle bases
      flames.add(flameNode);
      candleBases.add(baseNode);

      this.arCoreController.addArCoreNode(baseNode);
      this.arCoreController.addArCoreNode(flameNode);

      xPos += spacing;
    }
  }

  //Handles what happens when an object/the screen is tapped
  void onTapHandler(String nodesList) {
    //nodesList är det ljus som trycks på.
    var candleName = nodesList;
    var index = int.parse(candleName);
    var currentFlame = flames[index];

    //Changes the flame material so the candle lights up when tapped
    currentFlame.shape.materials.value = [flameLit];

    //If the candle hasn't been tapped, count the candle and change tapped
    //to true
    if (tapped[index] == false) {
      countCandle();
      tapped[index] = true;
    }
  }

  //Counts each time a new light is tapped
  countCandle() {
    counter++;
    //When all lights are tapped, the game ends
    if (counter == (numberOfCandles)) {
      widget.winCallback(); //Call callback function
    }
  }
}
