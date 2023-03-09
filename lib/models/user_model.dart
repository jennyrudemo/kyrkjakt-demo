/*
* Copyright (c) 2021 Fei Alm, Jessie Chow, Anna Wästling, David Styrbjörn, Jenny Rudemo
* This source code is licensed under the MIT-style license found in the
* LICENSE file in the root directory of this source tree.
*
* @author David Styrbjörn
* @date 2021-04-29
*
* @summary
* This class holds all relevant data that is stored between the sessions such as
* - where the player last left off
* - how many activities the player has completed
* - application language
* - cached data for church
*
* @structure
*/

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:kyrkjakt/models/church_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel extends ChangeNotifier {
  // Constructor
  UserModel(String languageFileContent) {
    // Create our shared prefernce member, see comment below that explains why i do this
    SharedPreferences.getInstance().then((value) {
      prefs = value;

      // Clear the cache for church
      prefs.remove("cached_church_data");
    });
    // Load all the language related data
    _loadLanguageMap(languageFileContent);
  }

  // Set in the constructor,
  // i do this to avoid calling SharedPreferences.getInstance() in every method!
  // lets us avoid using Future<...> everywhere
  SharedPreferences prefs;
  // 0 swedish, 1 english
  Map<String, dynamic> languageMap;
  int language = 0;

  // Returns the most recent activity-id for a church with given name
  // If not found function returns ["none"]
  String getMostRecentActivityID(String churchName) {
    return prefs.getString(churchName) ?? "none";
  }

  // Used to get the total number of completed activities given a
  // churchName as ID. For example "askeby_kyrka"
  List<String> getCompletedActivites(String churchName) {
    return prefs.getStringList(_getCompletedActivityKey(churchName)) ??
        <String>[]; // Return an empty list if we don't have any completed activities
  }

  // Increment the number of activities completed by +1 at a given churchName
  void addCompletedActivity(String churchName, String activityName) {
    // Get the current list of completed activities for this church
    List<String> list = getCompletedActivites(churchName);

    // We don't want any replicants since that will mess with the length so check for that first
    if (!list.contains(activityName)) {
      list.add(activityName);
    }

    // Add it back in
    String key = _getCompletedActivityKey(churchName);
    prefs.setStringList(key, list);

    notifyListeners();
  }

  bool hasCompletedAllActivites(ChurchModel church) {
    // Get the list of completed activities for this church
    List<String> list = getCompletedActivites(church.name);

    // Has the user completed all activities in the church?
    int x = church.activityList.length;
    // x = 2;
    if (list.length >= x) {
      return true;
    }

    return false;
  }

  bool getMarkedAsCompleteFlag(ChurchModel church) {
    return prefs.getBool(church.name + "_completed") ?? false;
  }

  /* Used to make sure we don't display "completed round!" everytime a user completes an activity */
  /* Only do it the first time the user has completed all activities at a church */
  void markChurchAsComplete(ChurchModel church) {
    prefs.setBool(church.name + "_completed", true);
  }

  bool hasCompletedActivityAtChurch(String churchName, String activityName) {
    return getCompletedActivites(churchName).contains(activityName);
  }

  // Sets the most recent activity-id for a church with given name
  void setMostRecentActivity(String churchName, String mostRecent) {
    prefs.setString(churchName, mostRecent);
  }

  // Used to clear the user persitent storage!
  // Do note that this clears ALL data for the app shared perf, might create problems later on.
  Future<bool> deleteData() {
    return prefs.clear();
  }

  Future<void> removeDataForChurch(String churchName) async {
    await prefs.remove(churchName);
    await prefs.remove(_getCompletedActivityKey(churchName));
  }

  // Utility method to help get the correct key
  String _getCompletedActivityKey(String churchName) {
    return churchName + "_actCount";
  }

  // Cached church data, json-string
  String getCachedChurchData() {
    return prefs.getString("cached_church_data") ?? "none";
  }

  // Cache json data for current church
  void cacheChurchData(String jsonData) {
    prefs.setString("cached_church_data", jsonData);
  }

  void _loadLanguageMap(String content) async {
    languageMap = jsonDecode(content);
  }

  void setLanguage(int index) {
    language = index;
    notifyListeners();
  }
}
