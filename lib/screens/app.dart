/*
* Copyright (c) 2021 Fei Alm, Jessie Chow, Anna Wästling, David Styrbjörn, Jenny Rudemo
* This source code is licensed under the MIT-style license found in the
* LICENSE file in the root directory of this source tree.
*
* @author Kyrkjakten
* @date 2021
* @summary
* @structure
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kyrkjakt/screens/fact_screen.dart';
import 'package:kyrkjakt/screens/game_progress_screen.dart';
import 'package:kyrkjakt/models/user_model.dart';
import 'package:kyrkjakt/screens/help_screen.dart';
import 'package:provider/provider.dart';
import 'church_select_screen.dart';
import 'home_screen.dart';
import 'activities/activity_screen.dart';
import 'about_screen.dart';

class App extends StatelessWidget {
  // This widget is the root of your application.
  const App();
  @override
  Widget build(BuildContext context) {
    // This locks the app in portrait mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    Provider.of<UserModel>(context,
        listen:
            false); // Do this to make sure the UserModel constructor is being called
    return MaterialApp(
      debugShowCheckedModeBanner: false, //remove debug logo in top right corner
      title: 'Kyrkjakten',
      // This is the theme of your application.
      theme: ThemeData(
        //Custom font set as default
        //If you want to acess foundry sterling bold write
        //fontWeight: FontWeight.bold,
        fontFamily: 'FoundrySterling',
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 50.0, color: Colors.white),
          headline2: TextStyle(
              fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.white),
          headline3: TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
          bodyText1: TextStyle(
              fontSize: 18.0, fontFamily: 'Book', color: Colors.white),
          bodyText2: TextStyle(
              fontSize: 14.0, fontFamily: 'Book', color: Colors.white),
          button: TextStyle(fontSize: 24.0, color: Colors.white),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          primary: Colors.orange, //Sets the color of the text
          shadowColor: Colors.black,
          elevation: 10,
        )),

        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => ChurchSelect(),
        '/home': (context) => HomeScreen(),
        '/fact': (context) => FactScreen(),
        '/activity_screen': (context) => ActivityScreen(),
        '/game_progress_screen': (context) => GameProgress(),
        '/help_screen': (context) => HelpScreen(),
        '/about_screen': (context) => AboutScreen(),
      },
    );
  }
}
