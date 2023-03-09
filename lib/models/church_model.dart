/*
* Copyright (c) 2021 Fei Alm, Jessie Chow, Anna Wästling, David Styrbjörn, Jenny Rudemo
* This source code is licensed under the MIT-style license found in the
* LICENSE file in the root directory of this source tree.
*
* @author David Styrbjörn
* @date 
* @summary
Sets correct elements to display in church screen

* @structure 
Initialises the elements with data from the database
*/

import 'package:flutter/cupertino.dart';
import 'content_model.dart';
import 'activity_model.dart';

class ChurchModel extends ChangeNotifier {
  // Private Members
  List<ContentModel> _news;
  List<ActivityModel> _activityList;
  String _name;
  String _coverImage;

  // Getters
  List<ContentModel> get news => _news;
  List<ActivityModel> get activityList => _activityList;
  String get name => _name;
  String get coverImageUrl => _coverImage;

  ChurchModel();

  // Utility method for getting an activity model by its id, for example "count_game" would return the count activity
  ActivityModel getActivityById(String id) {
    // Look through the activities and find the one with given id
    for (var act in _activityList) {
      if (act.id == id) return act;
    }

    // If no activity was found return the first one and print a warning
    print("getActivityById did not find an activity with id: " + id);
    return _activityList[0];
  }

  // Function to convert the json from the firebase storage to a church model object
  void takeJsonData(Map<String, dynamic> json) {
    // Map through each news element and map it to our List
    _news = List<ContentModel>.from(
        json["news"].map((x) => ContentModel.fromJson(x)));

    _activityList = List<ActivityModel>.from(json["activity_list"]
        .map((x) => ActivityModel.fromJson(x))); // Same as for the news

    _name = json["name"]; // Simply grab
    _coverImage = json["cover_image"]; // Simply grab

    notifyListeners();
  }
}
