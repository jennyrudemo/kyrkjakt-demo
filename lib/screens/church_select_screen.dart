/*
* Copyright (c) 2021 Fei Alm, Jessie Chow, Anna Wästling, David Styrbjörn, Jenny Rudemo
* This source code is licensed under the MIT-style license found in the
* LICENSE file in the root directory of this source tree.
*
* @author 
* @date 
* @summary
* @structure
*/

import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:kyrkjakt/config/color_config.dart';
import 'package:kyrkjakt/models/church_model.dart';
import 'package:kyrkjakt/models/user_model.dart';
import 'package:kyrkjakt/services/firebase_service.dart';
import 'package:kyrkjakt/widgets/medium_text_icon_button.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GeoPoint {
  double longitude;
  double latitude;

  GeoPoint({this.longitude: -1, this.latitude: -1});

  // Helper method to calculate position to other churches
  static double getDistance(GeoPoint a, GeoPoint b) {
    return sqrt(
        pow(a.longitude - b.longitude, 2) + pow(a.latitude - b.latitude, 2));
  }
}

class ChurchSelect extends StatefulWidget {
  @override
  _ChurchSelectState createState() => _ChurchSelectState();
}

class _ChurchSelectState extends State<ChurchSelect> {
  final double countryIconSize = 48;
  String language = "swe"; // Language state
  String selectedChurchName; // State which holds the selected church_id

  List<String> churchList = ["test"];
  Map<String, GeoPoint> positionMap = new Map<String,
      GeoPoint>(); // Maps church id to position (longitude, latitude)

  bool loading = false;

  // Create a new Firebase Auth instance, call the instance getter on FirebaseAuth
  FirebaseAuth auth = FirebaseAuth.instance;

  Widget getLogo() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Image.asset("assets/images/SvenskaKyrkan_logo2.png",
            height: 20, width: 140),
      ),
    );
  }

  // Used in the top half to represent the app icon
  Widget getAppIcon() {
    return Align(
      alignment: Alignment.topCenter,
      child:
          Image.asset("assets/images/logo_round.png", width: 128, height: 128),
    );
  }

  // Used by buttons to create a shadow
  BoxShadow getButtonShadow() {
    return BoxShadow(
      color: Colors.black.withOpacity(0.2),
      spreadRadius: 3,
      blurRadius: 5,
      offset: Offset(0, 2), // Change shadow position
    );
  }

// All this very complicated call does it capture the correct church_model and make our provider state THAT church_model
  // After that's all done, navigate the homescreen
  void getCorrectChurch() async {
    var user = Provider.of<UserModel>(context, listen: false);

    // Check if there is cached data, returns "none" if there's no cached data
    String cachedString = user.getCachedChurchData();
    if (cachedString != "none") {
      Provider.of<ChurchModel>(context, listen: false)
          .takeJsonData(jsonDecode(cachedString));
      Navigator.pushNamed(context, '/home');
    } else {
      setState(() {
        loading = true;
      });
      // Authenticate using firebase
      auth.signInAnonymously().then((UserCredential uc) {
        // Load the church data
        FirebaseService()
            .getCorrectChurchModel(selectedChurchName)
            .then((snapshot) {
          if (snapshot.docs.length != 1)
            print(
                "Error when trying to retrieve church! Recived zero or more than 1 church document");
          else {
            // The snapshot's one and only docu ment should the the wanted church document
            Provider.of<ChurchModel>(context, listen: false)
                .takeJsonData(snapshot.docs[0].data());

            // Cache the data in the user model
            user.cacheChurchData(json.encode(snapshot.docs[0].data()));

            // Navigate to the homescreen
            Navigator.pushNamed(context, '/home');
            setState(() {
              loading = false;
            });
          }
        });
      });
    }
  }

  Widget getDeleteDataButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: TextButton(
        child: Text("REMOVE DATA"),
        onPressed: () {
          Provider.of<UserModel>(context, listen: false)
              .deleteData()
              .then((bool value) {
            {
              if (value)
                print("CLEARED PERSITENT DATA!!!");
              else
                print("TRIED TO CLEAR DATA, FAILED!!!");
            }
          });
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Consumer<UserModel>(
      builder: (context, user, child) => Container(
        color: ColorConfig().darkBlue,
        child: loading
            ? FittedBox(
                child: Center(
                    child: AutoSizeText(
                user.languageMap["loading"][user.language] + "...",
                style: Theme.of(context).textTheme.headline1,
              )))
            : Column(
                children: [
                  Expanded(flex: 1, child: Container()),
                  Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //Icon
                        getAppIcon(),
                        //Welcome text
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: AutoSizeText(
                            user.languageMap["church_select_welcome"]
                                [user.language],
                            style: Theme.of(context).textTheme.bodyText1,
                            maxLines: 1,
                            minFontSize: 12,
                          ),
                        ),
                        AutoSizeText(
                          "KYRKJAKTEN",
                          style: Theme.of(context).textTheme.headline1,
                          minFontSize: 24,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: AutoSizeText(
                            user.languageMap["church_select_title"]
                                [user.language],
                            style: Theme.of(context).textTheme.bodyText1,
                            maxLines: 1,
                            minFontSize: 12,
                          ),
                        ),
                        //Begin button
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 32.0, left: 100.0, right: 100.0),
                          child: mediumTextIconButton(
                              user.languageMap["start"][user.language],
                              Icons.play_arrow,
                              Colors.orange,
                              getCorrectChurch,
                              context)

                          /*getBeginButton(user)*/,
                        ),
                        //Explainatory text
                        FractionallySizedBox(
                          widthFactor: 0.4,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: AutoSizeText(
                              user.languageMap["church_select_hint"]
                                  [user.language],
                              style: Theme.of(context).textTheme.bodyText2,
                              maxLines: 2,
                              minFontSize: 10,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //Logo for the Swedish church in footer
                  Expanded(
                    flex: 1,
                    child: getLogo(),
                  )
                ],
              ),
      ),
    ));
  }
}

// String determineClosestChurch(Position position) {
//   // Declare variables
//   GeoPoint userPosition =
//       GeoPoint(longitude: position.longitude, latitude: position.latitude);
//   String closestName = "";
//   double currentClosest = double.maxFinite; // Base case
//   // Loop through the map of church and positions to find the closest
//   positionMap.forEach((key, value) {
//     double dist = GeoPoint.getDistance(userPosition, value);
//     if (dist < currentClosest) {
//       currentClosest = dist;
//       closestName = key;
//     }
//   });
//   // Return the found church name
//   return closestName;
// }
