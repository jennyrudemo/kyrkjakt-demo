/*
* Copyright (c) 2021 Fei Alm, Jessie Chow, Anna Wästling, David Styrbjörn, Jenny Rudemo
* This source code is licensed under the MIT-style license found in the
* LICENSE file in the root directory of this source tree.
*/

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'models/activity_model.dart';
import 'models/church_model.dart';
import 'models/user_model.dart';
import 'screens/app.dart';

void main() async {
  // This was added to ensure that the firebase is ALWAYS initalized
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Load the language json file before the app is launched
  String languageFileContent =
      await rootBundle.loadString('assets/language/language.json');

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<ChurchModel>(create: (context) => ChurchModel()),
      ChangeNotifierProvider<ActivityModel>(
          create: (context) => ActivityModel()),
      ChangeNotifierProvider<UserModel>(
          create: (context) => UserModel(languageFileContent))
    ],
    child: App(),
  ));
}
