/*
* Copyright (c) 2021 Fei Alm, Jessie Chow, Anna Wästling, David Styrbjörn, Jenny Rudemo
* This source code is licensed under the MIT-style license found in the
* LICENSE file in the root directory of this source tree.
*
* @author Anna Wästling
* @date 2021-05-18
*
* @summary 
* Find a cross called marker in the code, click it and you get a treasure chest 
* from url. 
*
* @structure:       
*/

import 'dart:math';
import 'dart:ui';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:kyrkjakt/models/activity_model.dart';
import 'package:provider/provider.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class FindTreasureAndroid extends StatefulWidget {
  @override
  _FindTreasureAndroidState createState() => _FindTreasureAndroidState();

  //Define callback
  final VoidCallback winCallback;
  //Constructor using callback
  FindTreasureAndroid(this.winCallback);
}

class _FindTreasureAndroidState extends State<FindTreasureAndroid> {
  // The controller will hold all the nodes in the scene
  ArCoreController arCoreController;
  double yPos = -6;

  //Create the view and adding function call
  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    //when a node with name is tapped call onTapHandler (defined further down)
    arCoreController.onNodeTap = (name) => onTapHandler(name);
    //node1 is half of a cross
    final node1 = ArCoreNode(
      name: "marker1",
      shape: ArCoreCube(
          size: vector.Vector3(2.0, 0.02, 0.4),
          materials: [ArCoreMaterial(color: Colors.red)]),
      //the position gets randomized in x and z further down depending on the difficulty
      position: vector.Vector3(xPos.toDouble(), yPos, zPos.toDouble()),
      //gets a small rotation on the y-axis to create the cross
      rotation: vector.Vector4(0, 1, 0, 0.6),
    );
    //other half of the cross
    final node2 = ArCoreNode(
      name: "marker2",
      shape: ArCoreCube(
          size: vector.Vector3(2.0, 0.02, 0.4),
          materials: [ArCoreMaterial(color: Colors.red)]),
      //the position gets randomized in x and z further down depending on the difficulty
      position: vector.Vector3(xPos.toDouble(), yPos, zPos.toDouble()),
      //gets a small rotation on the y-axis to create the cross
      rotation: vector.Vector4(0, 1, 0, -0.3),
    );
    //add the nodes to the controller
    this.arCoreController.addArCoreNode(node1);
    this.arCoreController.addArCoreNode(node2);
  }

  //Create treasurechest from url
  void _addTreasureChest() {
    final treasureChestNode = ArCoreReferenceNode(
        name: "TreasureChest2",
        objectUrl:
            "https://raw.githubusercontent.com/Kyrkjakten/project_files/main/ts.gltf",
        //same position as the cross
        position: vector.Vector3(xPos.toDouble(), yPos, zPos.toDouble()),
        //small roation to show 3d object
        rotation: vector.Vector4(0, 1, 0, -pi / 2));
    //add the node where the cross is
    arCoreController.addArCoreNodeWithAnchor(treasureChestNode);
  }

  //when tapped, if name is the cross add treasurechest,
  //when treasurechest is clicked, wincallback is called
  void onTapHandler(String name) {
    if (name == "marker1" || name == "marker2") {
      //add the treasurechest
      _addTreasureChest();
      //remove the cross so no more treasurechest can be added
      arCoreController.removeNode(nodeName: "marker1");
      arCoreController.removeNode(nodeName: "marker2");
    } else {
      widget.winCallback();
    }
  }

  //position in x-axis and z-axis
  var zPos;
  var xPos;

  //Set number of candles depending of the difficulty level
  void initState() {
    var activity = Provider.of<ActivityModel>(context, listen: false);
    //set random numbers
    Random rxPos = new Random();
    Random rzPos = new Random();

    if (activity.isEasy) {
      // random numbers in range from -3 to -7
      zPos = -rzPos.nextInt(6) - 2;
      // random numbers in range from -3 to -20
      xPos = rxPos.nextInt(28) - 2;
    } else {
      // random numbers in range from -3 to -11
      zPos = -rzPos.nextInt(10) - 2;
      // random numbers in range from -3 to -20
      xPos = -rxPos.nextInt(28) - 2;
    }
    super.initState();
  }

  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }

  //Builds the AR layout and window
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ArCoreView(
        enableTapRecognizer: true, //Enables tapping
        onArCoreViewCreated: _onArCoreViewCreated, //Includes AR view
      ),
    );
  }
}
