/*
* Copyright (c) 2021 Fei Alm, Jessie Chow, Anna Wästling, David Styrbjörn, Jenny Rudemo
* This source code is licensed under the MIT-style license found in the
* LICENSE file in the root directory of this source tree.
*
* @author Jenny Rudemo
* @date 2021
* @summary Find a cross called marker in the code, click it and you get a treasure chest 
* @structure
*/

import 'dart:math';
import 'dart:ui';
import 'dart:core';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:kyrkjakt/models/activity_model.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class FindTreasureIOS extends StatefulWidget {
  @override
  _FindTreasureIOSState createState() => _FindTreasureIOSState();

  //Define callback
  final VoidCallback winCallback;
  //Constructor using callback
  FindTreasureIOS(this.winCallback);
}

class _FindTreasureIOSState extends State<FindTreasureIOS> {
  // The controller will hold all the nodes in the scene
  ARKitController arkitController;
  //position in x-axis and z-axis
  var zPos;
  var xPos;
  double yPos = -6;

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
    arkitController?.dispose();
    super.dispose();
  }

  //Builds the AR layout and window
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ARKitSceneView(
        enableTapRecognizer: true, //Enables tapping
        onARKitViewCreated: _onARKitViewCreated, //Includes AR view
      ),
    );
  }

  //Create the view and adding function call
  void _onARKitViewCreated(ARKitController controller) {
    this.arkitController = controller;
    //when a node with name is tapped call onTapHandler (defined further down)
    this.arkitController.onNodeTap = (nodes) => onTapHandler(nodes);

    //node1 is half of a cross
    final node1 = ARKitNode(
      name: "marker1",
      geometry: ARKitBox(
        length: 2.0,
        height: 0.02,
        width: 0.4,
        materials: [
          ARKitMaterial(
            diffuse: ARKitMaterialProperty(
              color: Colors.red,
            ),
          )
        ],
      ),
      //the position gets randomized in x and z further down depending on the difficulty
      position: vector.Vector3(xPos.toDouble(), yPos, zPos.toDouble()),
      //gets a small rotation on the y-axis to create the cross
      rotation: vector.Vector4(0, 1, 0, pi / 4),
    );

    //other half of the cross
    final node2 = ARKitNode(
      name: "marker2",
      geometry: ARKitBox(
        length: 2.0,
        height: 0.02,
        width: 0.4,
        materials: [
          ARKitMaterial(
            diffuse: ARKitMaterialProperty(
              color: Colors.red,
            ),
          )
        ],
      ),
      //the position gets randomized in x and z further down depending on the difficulty
      position: vector.Vector3(xPos.toDouble(), yPos, zPos.toDouble()),
      //gets a small rotation on the y-axis to create the cross
      rotation: vector.Vector4(0, 1, 0, -pi / 4),
    );

    //add the nodes to the controller
    this.arkitController.add(node1);
    this.arkitController.add(node2);
  }

  void _addTreasureChest() {
    //Define material for treasure chest
    final wood = ARKitMaterial(
      diffuse: ARKitMaterialProperty(
          image: 'assets/3dModels/treasure_chest/wood.jpg'),
    );

    //Meassures for the treasure chest
    final chestDepth = 1.6;
    final chestWidth = 2.4;
    final boxHeight = 1.2;
    final lockOffset = 0.2; //offsets the lock from the top of the chest

    //Defines positions for the different parts of the chest
    final boxPos = vector.Vector3(xPos.toDouble(), yPos, zPos.toDouble());
    final topPos =
        vector.Vector3(xPos.toDouble(), yPos + boxHeight / 2, zPos.toDouble());
    final lockPos = vector.Vector3(
        xPos.toDouble(), yPos + boxHeight / 2 - lockOffset, zPos.toDouble());

    //Box
    final box = ARKitBox(
      length: chestDepth,
      width: chestWidth,
      height: boxHeight,
      materials: [wood],
    );

    //Box node
    final boxNode = ARKitNode(
      name: "box",
      geometry: box,
      position: boxPos,
    );

    //Cylinder
    final top = ARKitCylinder(
      height: chestWidth,
      radius: chestDepth / 2,
      materials: [wood],
    );

    //Cylinder node, sideways
    final topNode = ARKitNode(
      name: "topOfChest",
      geometry: top,
      position: topPos,
      rotation: vector.Vector4(0, 0, 1, pi / 2),
    );

    //Lock
    final lock = ARKitCylinder(
      height: chestDepth + lockOffset,
      radius: chestWidth / 10,
      materials: [
        ARKitMaterial(
          diffuse: ARKitMaterialProperty(color: Colors.yellow),
        ),
      ],
    );

    //Lock node
    final lockNode = ARKitNode(
      name: "lock",
      geometry: lock,
      position: lockPos,
      rotation: vector.Vector4(1, 0, 0, pi / 2),
    );

    this.arkitController.add(boxNode);
    this.arkitController.add(topNode);
    this.arkitController.add(lockNode);
  }

  //when tapped, if name is the cross add treasurechest,
  //when treasurechest is clicked, wincallback is called
  void onTapHandler(List<String> nodes) {
    //Check if the first element in the list of nodes is either one of the markers
    if (nodes.first == "marker1" || nodes.first == "marker2") {
      //add the treasurechest
      _addTreasureChest();

      //remove the cross so no more treasurechest can be added
      this.arkitController.remove("marker1");
      this.arkitController.remove("marker2");
    } else {
      widget.winCallback();
    }
  }
}
