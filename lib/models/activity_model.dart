/*
* Copyright (c) 2021 Fei Alm, Jessie Chow, Anna Wästling, David Styrbjörn, Jenny Rudemo
* This source code is licensed under the MIT-style license found in the
* LICENSE file in the root directory of this source tree.
*
* @author
* @date 
*
* @summary
* Sets correct elements to display in activity screen
*
* @structure 
* Initialises the elements with data from the database
*/

import 'package:flutter/cupertino.dart';
import 'package:kyrkjakt/models/church_model.dart';
import 'package:kyrkjakt/models/user_model.dart';

class ActivityModel extends ChangeNotifier {
  //Elements to be used in activity screen
  List<String> assets;
  List<String> clue;
  List<String> clueEasy;
  List<String> description;
  List<String> factoidContent;
  List<String> factoidTitle;
  String id;
  List<dynamic> instruction;
  List<dynamic> instructionEasy;
  String nextId;
  List<dynamic> title;

  // Used to toggle between difficulty levels
  bool isEasy = false;

  // TODO is this still used???
  int number = 0;

  ActivityModel({
    this.assets,
    this.clue,
    this.clueEasy,
    this.description,
    this.factoidContent,
    this.factoidTitle,
    this.id: "no-id",
    this.instruction,
    this.instructionEasy,
    this.nextId,
    this.title,
  });

  void setNewActivity(ActivityModel newActivity) {
    this.assets = newActivity.assets;
    this.clue = newActivity.clue;
    this.clueEasy = newActivity.clueEasy;
    this.description = newActivity.description;
    this.factoidContent = newActivity.factoidContent;
    this.factoidTitle = newActivity.factoidTitle;
    this.id = newActivity.id;
    this.instruction = newActivity.instruction;
    this.instructionEasy = newActivity.instructionEasy;
    this.nextId = newActivity.nextId;
    this.title = newActivity.title;

    number++;

    notifyListeners();
  }

  // This function is called and checks with the usermodel which activity was played recently
  // If no recent activity can be found, select a random activity starting point
  void continueSession(UserModel userModel, ChurchModel churchModel) {
    // shared_preferences returns a Future<> so we use then to capture the value
    String recent = userModel.getMostRecentActivityID(churchModel.name);
    // Check if this is the first time the user tries to play in this church
    if (recent == "none") {
      setNewActivity(churchModel.activityList[0]);
    } else {
      // It is not the first time so simply continue and capture the most recent activity from the church activity list
      setNewActivity(churchModel.getActivityById(recent));
    }
  }

  // Toggles easy and notifies the listeners
  void toggleEasy() {
    isEasy = !isEasy;
    notifyListeners();
  }

  // This method will be used when capturing data from the firebase-api.
  // It is called from church_model.dart json factory
  // Map through each element, example of element: description_swe
  // Return data of every activity for a church into the _activityList list, see church_model.dart
  factory ActivityModel.fromJson(Map<String, dynamic> json) => ActivityModel(
        assets: List<String>.from(json["assets"].map((x) => x)),
        clue: List<String>.from(json["clue"].map((x) => x)),
        clueEasy: List<String>.from(json["clue_easy"].map((x) => x)),
        description: List<String>.from(json["description"].map((x) => x)),
        factoidContent:
            List<String>.from(json["factoid_content"].map((x) => x)),
        factoidTitle: List<String>.from(json["factoid_title"].map((x) => x)),
        id: json["id"],
        instruction: List<dynamic>.from(json["instruction"].map((x) => x)),
        instructionEasy:
            List<dynamic>.from(json["instruction_easy"].map((x) => x)),
        nextId: json["next_id"],
        title: List<dynamic>.from(json["title"].map((x) => x)),
      );
}
