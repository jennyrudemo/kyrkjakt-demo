/*
* Copyright (c) 2021 Fei Alm, Jessie Chow, Anna Wästling, David Styrbjörn, Jenny Rudemo
* This source code is licensed under the MIT-style license found in the
* LICENSE file in the root directory of this source tree.
*
* @author David Styrbjörn, Fei Alm, Jenny Rudemo
* @date 2021-03-16
*
* @summary This file contains all widgets used to create the kyrkjakt homescreen\
* you get here from the church_select_screen.dart (origin of application)\
*
* @structure:
* Each button is seperated into its own widget, for example the settings button is divided as:
* - getSettingsButtonContainer -> FractionallySizedBox(), returns the "container" in which the button can be created
* - getSettingsButton -> InkWell(), InkWell because it lets us handle touch event, the button content lives in these InkWell methods
*
* Each button follows the same structure. See getRewardsButton(), getGameButton(), getSettingsButton()
* To START reading through the code, go to the method getMenuButtons() and run through each button!
*
*/

import 'package:flutter/material.dart';
import 'package:kyrkjakt/config/color_config.dart';
import 'package:kyrkjakt/models/activity_model.dart';
import 'package:kyrkjakt/models/church_model.dart';
import 'package:kyrkjakt/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

const _backgroundColor = Color.fromRGBO(0, 111, 185, 1);

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double rewardsAndSettingsHeightScale = 0.65;
  double languageRegionHeightScale = 0.35;
  double gameButtonHeightScale = 0.4;

  // Function called when user clicks on the game button to start activities
  void onGameButtonClick(bool hasCompletedAllActivties) async {
    if (hasCompletedAllActivties) {
      // Delete all data option
      ChurchModel church = Provider.of<ChurchModel>(context, listen: false);
      Provider.of<UserModel>(context, listen: false)
          .setMostRecentActivity(church.name, church.activityList[0].id);
    }

    // Update the session, this preps for the activity screen arrival!
    // Looks weird becuase we have to get the provider states but all we're really doing is
    // -->  activity.continueSession(user, church);
    Provider.of<ActivityModel>(context, listen: false).continueSession(
        Provider.of<UserModel>(context, listen: false),
        Provider.of<ChurchModel>(context, listen: false));

    Navigator.pushNamed(
        context, "/activity_screen"); // Navigate to activity screen
  }

  final double padding = 8.0;
  BoxDecoration getButtonDecoration(Color color) {
    return BoxDecoration(
      color: color,
      border: Border.all(color: Colors.transparent),
      borderRadius: BorderRadius.all(Radius.circular((16.0))),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.5),
          offset: Offset(5, 5),
          blurRadius: 0.0,
        )
      ],
    );
  }

  Widget header(BuildContext context) {
    var user = Provider.of<UserModel>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          /* Icon */
          Expanded(
            flex: 2,
            child: getAppIcon(),
          ),
          Expanded(
            flex: 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                  child: AutoSizeText(
                    "KYRKJAKTEN",
                    minFontSize: 14,
                    maxFontSize: 40,
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ),
                Consumer<ChurchModel>(
                  builder: (context, church, child) => AutoSizeText(
                    user.languageMap["at"][user.language] + " " + church.name,
                    minFontSize: 24,
                    maxFontSize: 40,
                    style: TextStyle(
                        fontWeight: FontWeight.w300, color: Colors.white),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget getAppIcon() {
    return Container(
      child: Image.asset("assets/images/logo_round.png"),
    );
  }

  FractionallySizedBox getMenuButtons(BuildContext context, UserModel user) {
    return FractionallySizedBox(
      widthFactor: 0.875,
      heightFactor: 0.8,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: getGameButtonContainer(
              context,
              user,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: 1 - gameButtonHeightScale,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: getRewardsButtonContainer(context),
                  ),
                  // The next set of buttons are aligned to the bottom right
                  Align(
                    alignment: Alignment.topRight,
                    // Creates the region in which the 2 button lives
                    child: getHelpButtonContainer(context),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: getLanguageRegion(context),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  FractionallySizedBox getLanguageRegion(BuildContext context) {
    return FractionallySizedBox(
        widthFactor: 1.0,
        heightFactor: languageRegionHeightScale,
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: getLanguageRegionContent(),
        ));
  }

  Widget getLanguageRegionContent() {
    var user = Provider.of<UserModel>(context, listen: false);

    return Container(
      decoration: getButtonDecoration(ColorConfig().darkBlue),
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: 0.5,
            heightFactor: 1.0,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: AutoSizeText(
                  user.languageMap["language"][user.language],
                  style: Theme.of(context).textTheme.headline2,
                  minFontSize: 8,
                  maxFontSize: 20,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              // heightFactor: 1.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: getLanguageRegionFlags(),
              ),
            ),
          )
          // Flags
        ],
      ),
    );
  }

  List<Widget> getLanguageRegionFlags() {
    var user = Provider.of<UserModel>(context, listen: false);
    double countryIconSize = 40;
    return [
      // Swedish flag
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Opacity(
          opacity: user.language == 0 ? 1.0 : 0.5,
          child: InkWell(
            child: Image.asset(
              "assets/images/icons/sweden.png",
              width: countryIconSize,
              height: countryIconSize,
            ),
            onTap: () {
              user.setLanguage(0);
              setState(() {});
            },
          ),
        ),
      ),
      // UK flag
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Opacity(
          opacity: user.language == 1 ? 1.0 : 0.5,
          child: InkWell(
              child: Image.asset(
                "assets/images/icons/united-kingdom.png",
                width: countryIconSize,
                height: countryIconSize,
              ),
              onTap: () {
                user.setLanguage(1);
                setState(() {});
              }),
        ),
      )
    ];
  }

  FractionallySizedBox getGameButtonContainer(
      BuildContext context, UserModel user) {
    double scale = 1.0;
    return FractionallySizedBox(
      widthFactor: 1.0 * scale,
      heightFactor: gameButtonHeightScale * scale,
      child: Padding(
        padding: EdgeInsets.all(padding),
        // Here is the actual "button"
        child: getGameButton(context, user),
      ),
    );
  }

  InkWell getGameButton(BuildContext context, UserModel user) {
    ChurchModel church = Provider.of<ChurchModel>(context, listen: false);
    String title = user.languageMap["play"][user.language];

    // Check if the user has completed all activities
    bool hasCompletedAllActivies = user.hasCompletedAllActivites(church);

    return InkWell(
      child: Container(
          decoration:
              getButtonDecoration(ColorConfig().homeScreenActivityButton),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 10.0),
            child: Row(
              children: [
                // Add the titel of the button
                Expanded(
                  flex: 5,
                  child: Center(
                    child: AutoSizeText(
                      title,
                      style: Theme.of(context).textTheme.headline1,
                      //maxFontSize: 50,
                      minFontSize: 35,
                      maxLines: 1,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 80,
                    ),
                  ),
                ),
                // Add the chest image
                Expanded(
                  flex: 2,
                  child: Image.asset(
                    "assets/images/icons/door2.png",
                  ),
                ),
              ],
            ),
          )), // Add the button content etc
      onTap: () => onGameButtonClick(hasCompletedAllActivies),
    );
  }

  // Button for rewards and progress
  FractionallySizedBox getRewardsButtonContainer(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.5,
      heightFactor: rewardsAndSettingsHeightScale,
      // Actual button
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: getRewardsButton(context),
      ),
    );
  }

  InkWell getRewardsButton(BuildContext context) {
    var user = Provider.of<UserModel>(context, listen: false);
    return InkWell(
      child: Container(
        decoration: getButtonDecoration(ColorConfig().homeScreenRewardsButton),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            children: [
              // The settings icon
              Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  "assets/images/icons/reward_icon.png",
                  width: 70,
                  height: 70,
                ),
              ),
              // The title text
              Padding(
                padding: const EdgeInsets.only(top: 7.0),
                child: FittedBox(
                  child: AutoSizeText(
                    user.languageMap["progress_button_title"][user.language],
                    style: Theme.of(context).textTheme.headline3,
                    maxFontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, "/game_progress_screen");
      },
    );
  }

  // Creates the area in which the green settings button lives
  FractionallySizedBox getHelpButtonContainer(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.5,
      heightFactor: rewardsAndSettingsHeightScale,
      // Actual button
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: getHelpButton(context),
      ),
    );
  }

  InkWell getHelpButton(BuildContext context) {
    var user = Provider.of<UserModel>(context, listen: false);
    return InkWell(
      child: Container(
        decoration: getButtonDecoration(ColorConfig().homeScreenSettingsButton),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            children: [
              // The settings icon
              Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  "assets/images/icons/help.png",
                  width: 60,
                  height: 60,
                ),
              ),
              // The title text
              Padding(
                padding:
                    const EdgeInsets.only(top: 10.0, left: 8.0, right: 8.0),
                child: FittedBox(
                  child: AutoSizeText(
                    user.languageMap["help_button_title"][user.language],
                    style: Theme.of(context).textTheme.headline3,
                    minFontSize: 15,
                    maxFontSize: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, "/help_screen");
      },
    );
  }

  Widget footer() {
    return Padding(
      padding: const EdgeInsets.only(left: 3.0, bottom: 10.0),
      child: Align(
        alignment: Alignment.center,
        child: Image.asset("assets/images/SvenskaKyrkan_logo2.png",
            height: 20, width: 140),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: FractionallySizedBox(
              widthFactor: 0.9,
              heightFactor: 0.9,
              child: header(context),
            ),
          ),

          // This creates the "expanded" region in which our buttons resides
          Consumer<UserModel>(
            builder: (context, user, child) {
              return Expanded(
                flex: 7,
                child: Padding(
                  padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: ColorConfig().lightBlue,
                      child: getMenuButtons(context, user),
                    ),
                  ),
                ),
              );
            },
          ),
          Expanded(
            flex: 1,
            child: footer(),
          )
        ],
      ),
      color: _backgroundColor,
    );
  }
}
