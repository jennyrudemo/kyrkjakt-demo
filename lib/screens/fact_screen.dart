/*
* Copyright (c) 2021 Fei Alm, Jessie Chow, Anna Wästling, David Styrbjörn, Jenny Rudemo
* This source code is licensed under the MIT-style license found in the
* LICENSE file in the root directory of this source tree.
*
* @author Kyrkjakten
* @date 2021
*
* @summary
* Screen to display fact about the object in the activity
*
* @structure
* Gets the data from the database and displays it
*/

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:kyrkjakt/config/color_config.dart';
import 'package:kyrkjakt/models/activity_model.dart';
import 'package:kyrkjakt/models/user_model.dart';
import 'package:kyrkjakt/widgets/church_picture_widget.dart';
import 'package:kyrkjakt/widgets/text_to_speech_button_widget.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class DisplayableFact {
  String title;
  String description;
}

class FactScreen extends StatefulWidget {
  @override
  _FactScreen createState() => _FactScreen();
}

class _FactScreen extends State<FactScreen> {
  Image image;

  // @override
  void initState() {
    getImage();
    super.initState();
  }

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

  DisplayableFact getRelevantFact(UserModel user) {
    // Structured as title + description
    DisplayableFact df = new DisplayableFact();

    // Get the state and check if it's available
    var activity = Provider.of<ActivityModel>(context, listen: false);
    print(activity.id);
    if (activity.id == "no-id") {
      df.title = "NO FACT TO DISPLAY";
      df.description = "ERROR IN THE APP, SORRY";
      return df;
    }
    df.description = activity.factoidContent[user.language];
    df.title = activity.factoidTitle[user.language];
    return df;
  }

  void getImage() async {
    var activity = Provider.of<ActivityModel>(context, listen: false);
    String imageURL = await firebase_storage.FirebaseStorage.instance
        .ref(activity.factoidContent[2])
        .getDownloadURL();

    //notifies that image has changed
    setState(() {
      image = Image.network(imageURL, fit: BoxFit.cover);
    });
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserModel>(context, listen: false);
    DisplayableFact df = getRelevantFact(user);
//gets the image from the database

    return Material(
      child: Container(
        color: ColorConfig().darkPurple,
        child: Column(
          children: [
            Expanded(
              flex: 6,
              child: topHalf(context, image),
            ),
            Expanded(
                flex: 2,
                child: TextToSpeechButton(
                  readUp: df.description,
                )),
            // Text section
            Expanded(
                flex: 2,
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
                  child: Container(
                    child: Center(
                      child: AutoSizeText(
                        df.title,
                        style: Theme.of(context).textTheme.headline2,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                      ),
                    ),
                  ),
                )),
            Expanded(
                flex: 8,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: AutoSizeText(
                      df.description,
                      style: Theme.of(context).textTheme.bodyText1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )),
            Expanded(
              flex: 3,
              child: getLogo(),
            )
          ],
        ),
      ),
    );
  }
}
