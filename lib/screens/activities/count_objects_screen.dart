/*
* Copyright (c) 2021 Fei Alm, Jessie Chow, Anna Wästling, David Styrbjörn, Jenny Rudemo
* This source code is licensed under the MIT-style license found in the
* LICENSE file in the root directory of this source tree.
*
* @author Jessie Chow 
* @date 2021-05-20
*
* @summary
* Activity: count objects
*
* @structure
* Gets data from the database through activity_model
* Sets the elements with the data
* Variable answerInput is used to check for the correct answer in the function submitAnswer
* Functions increaseValue and decreaseValue modifies answerInput 
*/

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kyrkjakt/config/color_config.dart';
import 'package:kyrkjakt/models/activity_model.dart';
import 'package:kyrkjakt/models/user_model.dart';
import 'package:kyrkjakt/widgets/clue_widget.dart';
import 'package:kyrkjakt/widgets/feedback_widget.dart';
import 'package:kyrkjakt/widgets/home_button_widget.dart';
import 'package:kyrkjakt/widgets/medium_text_icon_button.dart';
import 'package:kyrkjakt/widgets/round_icon_button.dart';
import 'package:kyrkjakt/widgets/text_to_speech_button_widget.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:auto_size_text/auto_size_text.dart';

class CountObjects extends StatefulWidget {
  @override
  _CountObjectsState createState() => _CountObjectsState();

  // Fields
  final VoidCallback winCallback;
  final VoidCallback skipCallback;
  // Constructor
  CountObjects(this.winCallback, this.skipCallback);
}

class _CountObjectsState extends State<CountObjects> {
  //Used to check if the answer is correct
  //Is modified with functions increaseValue and decreaseValue
  //Is displayed in the widget displayAnswer
  //Should eventually be able to be modified through text input
  int answerInput = 0;

  //variables to be initialised in initState()
  int correctAnswer = 0;
  String clueTitle = "Ledtråd"; //changes with language
  String clueContent = "";
  Image image;
  String instruction;

  // Determines if the help/clue screen should appear
  bool help = false;

  // @override
  void initState() {
    difficultyCheck();
    getImage();
    super.initState();
  }

  // Set variables that depend on difficulty
  void difficultyCheck() {
    var activity = Provider.of<ActivityModel>(context, listen: false);
    var user = Provider.of<UserModel>(context, listen: false);
    int language = user.language;

    if (!activity.isEasy) {
      correctAnswer = int.parse(activity.assets[2]);
      clueContent = activity.clue[language];
      instruction = activity.instruction[language];
    } else {
      correctAnswer = int.parse(activity.assets[1]);
      clueContent = activity.clueEasy[language];
      instruction = activity.instructionEasy[language];
    }
  }

  // sets the variable image with the image from the database
  void getImage() async {
    var activity = Provider.of<ActivityModel>(context, listen: false);
    String imageURL = await firebase_storage.FirebaseStorage.instance
        .ref(activity.assets[0])
        .getDownloadURL();

    //notifies that image has changed
    setState(() {
      image = Image.network(imageURL, fit: BoxFit.cover);
    });
  }

  // Called when help button is pressed
  void toggleHelp() {
    setState(() {
      help = !help;
    });
  }

  //Increases the value of answerInput by 1 when pressing the plusButton in the widget counterSection
  void increaseValue() {
    setState(() {
      answerInput++;
    });
  }

  //Decreases the value of answerInput by 1 when pressing the minusButton in the widget counterSection
  void decreaseValue() {
    setState(() {
      if (answerInput > 0) {
        answerInput--;
      }
    });
  }

  // Called when the user wants to submit an answer
  void submitAnswer(int ans) {
    if (ans == correctAnswer) {
      // answer is correct
      widget.winCallback();
    } else {
      // Handles wrong input from user
      showDialog(
        context: context,
        builder: (BuildContext context) => buildPopupDialog(context),
      );
    }
  }

  // Renders the fact screen when the info button ("i") is pressed
  void getFactScreen() {
    Navigator.pushNamed(context, "/fact");
  }

  //  Used to make a round button with a specified letter "input"
  // specifically plusButton and minusButton
  Widget roundTextButton(String input, VoidCallback onPressed) {
    return Container(
      //Sets the appearance of the button
      child: ElevatedButton(
        child: AutoSizeText(input),
        style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5)),
        //Sets the icon of the button to input
        //Action when the button is pressed
        //Prints to the console
        onPressed: () => onPressed(),
      ),
    );
  }

  //Used to make a title text with the string "input"
  Widget titleText(String input) {
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: AutoSizeText(input, //Sets the title with input
          minFontSize: 25,
          maxFontSize: 40,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline2 //Sets the font size
          ),
    );
  }

  //Used to set the body text with the string "input"
  Widget bodyText(String input) {
    return Padding(
      padding: EdgeInsets.only(top: 6.0),
      child: AutoSizeText(
        input, //Sets the body text with input
        textAlign: TextAlign.center, //Sets the text placement
        style: Theme.of(context).textTheme.bodyText1,
        maxLines: 5,
        minFontSize: 15,
      ),
    );
  }

  //Used to display the image "input"
  Widget imageSection(Image input) {
    const double niceLookingHeightFactor = 752.0;
    double height = MediaQuery.of(context).size.height;
    double scale = (height / niceLookingHeightFactor);

    return Padding(
      padding: EdgeInsets.only(bottom: 10.0),
      child: Container(
        height: 160 * scale,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10), //Makes the corners rounded
          child: input, //Image to be displayed
        ),
      ),
    );
  }

  //Used to display answerInput and is called in the widget countSection
  Widget displayAnswer() {
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: Container(
        alignment: Alignment.center, //Sets the content in the center
        height: 50, //Sets the height of the box
        width: 100, //Sets the width of the box
        //Sets the appearance of the box
        decoration: BoxDecoration(
          color: Colors.orange, //Sets the color of the box
          borderRadius:
              BorderRadius.circular(15), //Sets the roundness of the corners
        ),
        child: AutoSizeText('$answerInput', //Display the variable answerInput
            textAlign: TextAlign.center, //Sets the text placement
            style: Theme.of(context).textTheme.button //Sets the font size
            ),
      ),
    );
  }

  //Holds buttons "go back", "info" and "help"
  Widget topButtonSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.only(left: 15.0),
            alignment: Alignment.centerLeft,
            child: goHomeButton(context),
          ),
        ),
        // info button
        roundIconButton(
            Icons.info_outline, Colors.orange, getFactScreen, context),
        //help button
        roundIconButton(Icons.help_outline, Colors.orange, toggleHelp, context)
      ],
    );
  }

  //Holds title text, text to speech button and body text
  Widget textSection() {
    var user = Provider.of<UserModel>(context, listen: false);
    var activity = Provider.of<ActivityModel>(context, listen: false);
    return Container(
      width: 250, // Sets the width
      child: Column(
        children: [
          titleText(activity.title[user.language]), //Sets the title text
          TextToSpeechButton(
            readUp: instruction,
          ),
          bodyText(instruction),
        ],
      ),
    );
  }

  //Holds textSection and imageSection
  Widget body() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          textSection(),
          //This image is temporary. Use image connected to the activity
          imageSection(image),
        ],
      ),
    );
  }

  //Used in answerSection to display the widgets of the hard difficulty
  //Holds minusButton, displayAnswer, plusButton, "skip"-button and the "answer"-button
  Widget counterSection() {
    var user = Provider.of<UserModel>(context, listen: false);
    return Align(
      alignment: Alignment.topCenter,
      child: FractionallySizedBox(
        widthFactor: 0.9,
        heightFactor: 1.0,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  roundTextButton("-", decreaseValue), //minus button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: displayAnswer(),
                  ),
                  roundTextButton("+", increaseValue), //plus button
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // skip button
                  Expanded(
                      flex: 5,
                      child: mediumTextIconButton(
                          user.languageMap["skip"][user.language],
                          Icons.fast_forward,
                          Colors.orange,
                          widget.skipCallback,
                          context)),
                  Spacer(flex: 1),
                  // submit answer button
                  Expanded(
                      flex: 5,
                      child: mediumTextIconButton(
                          user.languageMap["submit"][user.language],
                          Icons.done,
                          ColorConfig().lightGreen, () {
                        submitAnswer(answerInput);
                      }, context))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  //The game screen
  Widget gameScreen() {
    return Material(
      child: Container(
        padding: EdgeInsets.only(top: 20.0),
        decoration: new BoxDecoration(color: ColorConfig().darkPurple),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: topButtonSection(),
            ),
            Expanded(
              flex: 7,
              child: body(),
            ),
            Expanded(
              flex: 3,
              child: counterSection(),
            )
          ],
        ),
      ),
    );
  }

// Show game or clue
  Widget getCorrectScreen() {
    Widget content = help
        ? Clue(
            backdropColor: ColorConfig().darkPurple,
            goBackCallback: () {
              setState(() {
                help = false;
              });
            },
          )
        : gameScreen();

    return content;
  }

  @override
  Widget build(BuildContext context) {
    return Material(child: getCorrectScreen());
  }
}
