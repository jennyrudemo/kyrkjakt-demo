/*
* Copyright (c) 2021 Fei Alm, Jessie Chow, Anna Wästling, David Styrbjörn, Jenny Rudemo
* This source code is licensed under the MIT-style license found in the
* LICENSE file in the root directory of this source tree.
*
* @author David Styrbjörn, Anna Wästling, Fei Alm
* @date 2021-03-24
*
* @summary
* Handles the connection between the home_screen, a game and the next game.
*
* @structure
* Widget for pre and post screens are implemented and changed
* depending on from where it is called. Uses activitystage to keep track on where we are,
* starting a game, in the game or finished a game. And calls for the pre or post screen.
*/

import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:kyrkjakt/config/color_config.dart';
import 'package:kyrkjakt/models/activity_model.dart';
import 'package:kyrkjakt/models/church_model.dart';
import 'package:kyrkjakt/models/user_model.dart';
import 'package:kyrkjakt/screens/activities/count_objects_screen.dart';
import 'package:kyrkjakt/screens/activities/puzzle_screen.dart';
import 'package:kyrkjakt/screens/activities/ar_activity_screen.dart';
import 'package:kyrkjakt/services/ar_availability.dart';
import 'package:kyrkjakt/widgets/activity_feedback.dart';
import 'package:kyrkjakt/widgets/continue_button_widget.dart';
import 'package:kyrkjakt/widgets/home_button_widget.dart';
import 'package:kyrkjakt/widgets/round_icon_button.dart';
import 'package:kyrkjakt/widgets/text_to_speech_button_widget.dart';
import 'package:kyrkjakt/widgets/yellow_button_widget.dart';
import 'package:provider/provider.dart';

enum ActivityStage {
  pre,
  playing,
  post,
  completed_all,
}

class ActivityScreen extends StatefulWidget {
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  // Keeps track of where we are in the activity-pipeline
  ActivityStage activityStage = ActivityStage.pre;

  // State variables for our popup
  Offset popupBegin = Offset(0, 0);
  Offset popupEnd = Offset(0, 0);
  bool skipFlag = false;
  bool arAvailable = false; //AR availability defaults to false
  bool letUserSkip = true;

  // used to set the text style for the text below the buttons in pre-activity screen
  TextStyle buttonText() {
    return TextStyle(
      fontFamily: 'FoundrySterling',
      color: Colors.white,
      fontSize: 11,
      fontWeight: FontWeight.normal,
    );
  }

  //Checks if the activity has already been completed
  //Displays a text if the activity has been completed, otherwise nothing
  Widget getCompletionText(ActivityModel activity) {
    UserModel user = Provider.of<UserModel>(context, listen: false);
    ChurchModel church = Provider.of<ChurchModel>(context, listen: false);

    // Do completion check
    if (!user.hasCompletedActivityAtChurch(church.name, activity.id))
      return Container();

    return Expanded(
      flex: 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 15, // Sets the size of the circle
            decoration: BoxDecoration(
              // Sets the shape and colour of the circle
              color: ColorConfig().lightGreen,
              shape: BoxShape.circle,
            ),
            child: Icon(
              // Sets the icon inside the circle
              Icons.done,
              color: Colors.white,
              size: 15,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Container(
              //Text to display if the activity is completed
              child: AutoSizeText(
                user.languageMap["pre_activity_completed"][user.language],
                style: TextStyle(
                  fontFamily: 'FoundrySterling',
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Layout for pre-activity screen
  Widget getPreActivityContent(ActivityModel activity) {
    var user = Provider.of<UserModel>(context, listen: false);
    return FractionallySizedBox(
      widthFactor: 0.85,
      child: Column(
        children: [
          // Top padding
          Expanded(
            flex: 3,
            child: Container(),
          ),
          // Header section with title and completion text
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FractionallySizedBox(
                  widthFactor: 0.9,
                  child: AutoSizeText(activity.title[user.language],
                      style: Theme.of(context).textTheme.headline2,
                      maxFontSize: 25,
                      minFontSize: 13,
                      maxLines: 1,
                      textAlign: TextAlign.center),
                ),
                // Text to notify the user that the activity is completed
                getCompletionText(activity),
              ],
            ),
          ),
          // Text to speech button
          Expanded(
            flex: 3,
            child:
                TextToSpeechButton(readUp: activity.description[user.language]),
          ),
          // Description text
          Expanded(
            flex: 5,
            child: Container(
              child: Center(
                child: FractionallySizedBox(
                  widthFactor: 0.85,
                  child: AutoSizeText(activity.description[user.language],
                      maxLines: 4,
                      minFontSize: 12,
                      maxFontSize: 15,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText1),
                ),
              ),
            ),
          ),

          // Difficulty switch
          Expanded(
            flex: 2,
            child: Transform.scale(
              scale: 0.95,
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AutoSizeText(
                      user.languageMap["pre_activity_lower_difficulty"]
                          [user.language],
                      style: Theme.of(context).textTheme.bodyText1,
                      maxLines: 1,
                      minFontSize: 20,
                      maxFontSize: 28,
                    ),
                    //Switch to toggle between easy and default mode
                    Switch(
                      value: activity.isEasy,
                      onChanged: (value) {
                        activity.toggleEasy();
                      },
                      activeTrackColor: Colors.yellow,
                      activeColor: Colors.orangeAccent,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Bottom buttons
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Spacer(),
                  //Home button
                  Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          goHomeButton(context),
                          AutoSizeText(
                            user.languageMap["home"][user.language],
                            textAlign: TextAlign.center,
                            style: buttonText(),
                          ),
                        ],
                      )),
                  Spacer(),
                  //Start game button
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        roundIconButton(Icons.play_arrow,
                            ColorConfig().lightGreen, onStartActivity, context),
                        AutoSizeText(
                          user.languageMap["play"][user.language],
                          textAlign: TextAlign.center,
                          style: buttonText(),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  //Skip game button
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        roundIconButton(
                            Icons.fast_forward,
                            ColorConfig().orangeButton,
                            onNextActivity,
                            context),
                        AutoSizeText(
                          user.languageMap["skip"][user.language],
                          textAlign: TextAlign.center,
                          style: buttonText(),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
          Spacer(flex: 3), // Bottom padding, same method as the top padding
        ],
      ),
    );
  }

  // Postactivity screen layout
  Widget getPostActivityContent() {
    var user = Provider.of<UserModel>(context, listen: false);
    return FractionallySizedBox(
      widthFactor: 0.85,
      child: Column(
        children: [
          Spacer(flex: 1), // padding on top
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Image.asset(
                    "assets/images/icons/reward_icon.png",
                    width: 85,
                    height: 85,
                  ),
                ),
                Spacer(),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: AutoSizeText(
                    user.languageMap["post_activity_title"][user.language],
                    style: Theme.of(context).textTheme.headline2,
                    maxLines: 1,
                  ),
                ),
                Spacer(),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      getContinueButton(() {
                        onNextActivity();
                        setState(() {
                          activityStage = ActivityStage.pre;
                        });
                      }, context),
                      AutoSizeText(
                        user.languageMap["continue"][user.language],
                        textAlign: TextAlign.center,
                        style: buttonText(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Spacer(flex: 1), // Bottom padding, same method as the top padding
        ],
      ),
    );
  }

  // Builds the popup widget
  Widget popupScreen(ActivityModel activity) {
    // Decide which content widget to render
    Widget content;
    if (activityStage == ActivityStage.pre) {
      content = getPreActivityContent(activity);
      // Reset skipstate
      skipFlag = false;
    } else if (activityStage == ActivityStage.completed_all) {
      content = allActivitiesCompleted(context);
    } else {
      content = getPostActivityContent();
    }

    //Handles the animation of the scroll
    double scrollScale = 1.0;
    return TweenAnimationBuilder<Offset>(
      duration: const Duration(milliseconds: 850),
      tween: Tween<Offset>(begin: popupBegin, end: popupEnd),
      curve: Curves.easeInCubic,
      onEnd: () {
        onPopUpDone();
      },
      builder: (BuildContext _, Offset value, Widget __) {
        return Transform.translate(
          offset: value,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/scroll.png"),
                  fit: BoxFit.fill,
                ),
              ),
              child: FractionallySizedBox(
                widthFactor: 0.9 * scrollScale,
                heightFactor: 0.8 * scrollScale,
                child: content,
              ),
            ),
          ),
        );
      },
    );
  }

  //Puts the scroll in a stack and blur out the bakground
  Widget getPopupStack(ActivityModel activity) {
    return (Stack(
      fit: StackFit.expand,
      children: <Widget>[
        getCurrentActivityWidget(),
        Positioned.fill(
          child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: popupScreen(activity)),
        ),
      ],
    ));
  }

  // Determines which Widget class to return based on the current activity name
  // Win callback is passed to the returned widget which is then
  // used to signal back when the activity is completed
  Widget getCurrentActivityWidget() {
    var activity = Provider.of<ActivityModel>(context, listen: false);
    var user = Provider.of<UserModel>(context, listen: false);

    // Check which activity widget to return
    if (activity.id == "count_activity" ||
        activity.id == "count_indentations_activity") {
      return CountObjects(onActivityCompleted, onActivitySkipped);
    } else if (activity.id == "puzzle_activity" ||
        activity.id == "painting_puzzle_activity") {
      return PuzzleScreen(
          onActivityCompleted, onActivitySkipped, setLetUserSkip);
    } else if (activity.id == "light_candles_activity" ||
        activity.id == "find_treasurechest_activity") {
      if (arAvailable) {
        return ArActivityScreen(onActivityCompleted, onActivitySkipped);
      } else {
        //tell user the activity is not available and give options
        return activityNotAvailable(onActivitySkipped, user, context);
      }
    }
    return Container();
  }

  // Called when the popup has completed its animation
  void onPopUpDone() {
    setState(() {
      if (activityStage == ActivityStage.pre && !skipFlag)
        activityStage = ActivityStage.playing;
    });
  }

  // Called from the preActivityScreen
  void onStartActivity() {
    setState(() {
      popupEnd = Offset(0, MediaQuery.of(context).size.height);
    });
  }

  // Sent as a callback to the current activity and is called by it when
  // the activity has been completed
  void onActivityCompleted() {
    // ** Handle the current activity being completed ** //
    setState(() {
      activityStage = ActivityStage.post;
      popupBegin = -popupEnd;
      popupEnd = Offset(0, 0);
      skipFlag = false;
    });

    // Only add ass completed if it was not "skipped"
    // Adding current activity to the completed
    Provider.of<UserModel>(context, listen: false).addCompletedActivity(
        Provider.of<ChurchModel>(context, listen: false).name,
        Provider.of<ActivityModel>(context, listen: false).id);

    var church = Provider.of<ChurchModel>(context, listen: false);
    var user = Provider.of<UserModel>(context, listen: false);

    // Do the check if we've completed all activities
    if (user.hasCompletedAllActivites(church) &&
        !user.getMarkedAsCompleteFlag(church)) {
      user.markChurchAsComplete(church);
      setState(() {
        activityStage = ActivityStage.completed_all;
      });
    }
  }

  // Sent as callback to activity, gets called when the user wants to skip.
  void onActivitySkipped() {
    setState(() {
      activityStage = ActivityStage.pre;
      popupBegin = Offset(0, 0);
      popupEnd = Offset(0, 0);
      skipFlag = true;
    });
    onNextActivity();
  }

  // This can be sent down to activities that require some setup that needs to be done
  // before the user is allowed to skip
  void setLetUserSkip(bool _letUserSkip) {
    letUserSkip = _letUserSkip;
  }

  // This is called from the postActivityScreen and should handle the transition
  // to a new activity object
  void onNextActivity() {
    // Get the states we need
    var activity = Provider.of<ActivityModel>(context, listen: false);
    var church = Provider.of<ChurchModel>(context, listen: false);
    var user = Provider.of<UserModel>(context, listen: false);

    // Get the logical next activity name
    var newActivity = church.getActivityById(activity.nextId);

    // Set the new activity values
    activity.setNewActivity(newActivity);

    // Save the most recent activity (this one) so if the user backs out
    // homescreen still knows which activity to prep for
    user.setMostRecentActivity(church.name, activity.id);
  }

  Widget getCurrentStage(ActivityModel activity) {
    // Switch case to decide which widget to render
    switch (activityStage) {
      case ActivityStage.pre:
      case ActivityStage.post:
        return getPopupStack(activity);
        break;
      case ActivityStage.playing:
        return getCurrentActivityWidget();
        break;
      case ActivityStage.completed_all:
        // TODO: This could probably be displayed nicer but works for now!
        return getPopupStack(activity);
        break;
    }
    return Container();
  }

  @override
  void initState() {
    isARavailable().then((bool available) {
      setState(() {
        arAvailable = available;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Consumer<ActivityModel>(builder: (context, activity, child) {
      return getCurrentStage(activity);
    }));
  }
}
