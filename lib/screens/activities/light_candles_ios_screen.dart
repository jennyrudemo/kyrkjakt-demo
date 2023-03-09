/*
* Copyright (c) 2021 Fei Alm, Jessie Chow, Anna Wästling, David Styrbjörn, Jenny Rudemo
* This source code is licensed under the MIT-style license found in the
* LICENSE file in the root directory of this source tree.
*
* @author Fei Alm, Jenny Rudemo
* @date 2021-04-29
* 
* @summary 
* Code for AR-game "Tända ljus" on iOS-platform
Describe here
* @structure: 
*/

import 'package:flutter/material.dart';
import 'package:kyrkjakt/models/activity_model.dart';
import 'package:kyrkjakt/services/randomizer_service.dart';
import 'package:provider/provider.dart';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class LightCandlesIOS extends StatefulWidget {
  @override
  _LightCandlesIOSState createState() => _LightCandlesIOSState();

  //Define callback
  final VoidCallback winCallback;
  //Constructor using callback
  LightCandlesIOS(this.winCallback);
}

class _LightCandlesIOSState extends State<LightCandlesIOS> {
  ARKitController arkitController;
  ARKitCylinder candle; //Declares candle
  ARKitCapsule flame; //Declares flame
  List<ARKitNode> flames = [];
  List<ARKitNode> candleBases = [];
  ARKitMaterial flameLit;
  ARKitMaterial flameDead;
  int counter = 0;

  //numberOfCandles needs to be a static member to be used in the initializer
  //of tapped
  static int numberOfCandles = 0; //Initialize number of candles
  var zPos; //Defines depth of candles
  var spacing; //Defines spacing between candles

  //Set number of candles depending of the difficulty level
  void initState() {
    var activity = Provider.of<ActivityModel>(context, listen: false);

    if (activity.isEasy) {
      //Number of candles for easier difficulty
      numberOfCandles = 5;
      zPos = randomizer(1.5);
      spacing = 0.2;
    } else {
      //Number of candles for harder difficulty
      numberOfCandles = 10;
      zPos = randomizer(2.0);
      spacing = 0.4;
    }
    super.initState();
  }

  List<bool> tapped = List<bool>.filled(numberOfCandles, false);

  @override
  void dispose() {
    arkitController?.dispose();
    super.dispose();
  }

  //Builds the AR layout and window
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ARKitSceneView(
        enableTapRecognizer: true, //Enables tapping
        onARKitViewCreated: onARKitViewCreated, //Includes AR view
      ),
    );
  }

  //Sets up the AR view
  void onARKitViewCreated(ARKitController arkitController) {
    this.arkitController = arkitController;
    this.arkitController.onNodeTap = (nodes) => onNodeTapHandler(nodes);

    //Defines a high and low value for y, which are toggled between when
    //creating the candles
    final yHigh = randomizer(0.5);
    final yLow = 0.0;

    //Defines x, y, and z coordinates for the candles
    var xPos = numberOfCandles / 2 * (-spacing);
    xPos = randomizer(xPos);
    var yPosBase = yLow;
    //zPos = -1.5; //Updated in initState depending on difficulty

    //Defines candle material
    final candleMaterial = ARKitMaterial(
      diffuse: ARKitMaterialProperty(
        color: Colors.white,
      ),
    );

    //Defines material for non-lit flame
    flameDead = ARKitMaterial(
      diffuse: ARKitMaterialProperty(
        color: Colors.orange,
      ),
      transparency: 0.4,
    );

    //Defines material for lit flame
    flameLit = ARKitMaterial(
      diffuse: ARKitMaterialProperty(
        color: Colors.orange,
      ),
      transparency: 1,
    );

    for (var i = 0; i < numberOfCandles; i++) {
      //Both geometries needs to be declared within the loop to get individual
      // geometries that can be changed individually

      //Defines candle geometry
      candle = ARKitCylinder(
        materials: [candleMaterial],
        radius: 0.03,
        height: 0.3,
      );

      //Defines flame
      flame = ARKitCapsule(
        materials: [flameDead],
        capRadius: 0.01,
        height: 0.06,
      );

      //Toggles between a high and low y position to get the candles more
      //spread out
      yPosBase = yPosBase == yLow ? yHigh : yLow;

      //Adds candle geometry to node
      final baseNode = ARKitNode(
        //Name just number to be able to use as index for list flames
        name: '$i',
        geometry: candle,
        position: vector.Vector3(xPos, yPosBase, zPos),
        //pos (0,0,0) is the phone's position
      );

      //Computes the y position for the flame
      var yPosFlame =
          yPosBase + candle.height.value / 2 + flame.height.value / 2;

      //Adds the flame geometry to node
      final flameNode = ARKitNode(
        //add i to differentiate the different nodes
        //makes it possible to light up all candles and not just one
        name: 'flame' + '$i',
        geometry: flame,
        position: vector.Vector3(xPos, yPosFlame, zPos),
      );

      //Add flame and candle base nodes to list of flames and candle bases
      flames.add(flameNode);
      candleBases.add(baseNode);

      this.arkitController.add(baseNode);
      this.arkitController.add(flameNode);

      xPos += spacing;
    }
  }

  //Counts each time a new light is tapped
  countCandle() {
    counter++;
    //print('räkna ljus');

    //When all lights are tapped, the game ends
    if (counter == (numberOfCandles)) {
      //print('Färdig!');
      widget.winCallback(); //Call callback function
    }
  }

  //Handles what happens when an object/the screen is tapped
  //Needs to be an ARKitTapResultHandler, which always takes List<String> as
  //argument
  void onNodeTapHandler(List<String> nodesList) {
    //nodeList.first är det ljus som trycks på.
    var candleName = nodesList.first;
    var index = int.parse(candleName);
    var currentFlame = flames[index];
    //var flameName = currentFlame.name;

    //Debug
    /*print(flameName);
    print("tapped on $candleName");*/

    //Changes the flame material so the candle lights up when tapped
    currentFlame.geometry.materials.value = [flameLit];

    //If the candle hasn't been tapped, count the candle and change tapped
    //to true
    if (tapped[index] == false) {
      countCandle();
      tapped[index] = true;
    }
  }
}
