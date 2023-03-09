/*
* Copyright (c) 2021 Fei Alm, Jessie Chow, Anna Wästling, David Styrbjörn, Jenny Rudemo
* This source code is licensed under the MIT-style license found in the
* LICENSE file in the root directory of this source tree.
*
* @author Jenny Rudemo
* @date 2021-05-25
*
* @summary
* Determines if AR features are available on the device
*
* @structure
* Depends on the OS version and if camera access has been granted
*/

import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> isARavailable() async {
  bool cameraAvailable; //AR availability defaults to false
  bool arCompatible = false; //AR compatibility defaults to false

  // Find version literal for android and iOS
  String versionLiteral = "";
  if (Platform.isAndroid) {
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    versionLiteral = androidInfo.version.release;
  } else {
    var iosInfo = await DeviceInfoPlugin().iosInfo;
    versionLiteral = iosInfo.systemVersion;
  }

  //In case the version is presented on the format "X.Y.Z", versionLiteral is
  //set to X
  List<String> temp = versionLiteral.split(".");
  versionLiteral = temp.first;

  // Try to parse version
  double version = double.tryParse(versionLiteral);
  if (version == null) {
    // If no version can be found
    return false;
  }

  //check if the OS supports AR
  //for Android from version 7.0 and for iOS from version 11.0
  if ((Platform.isIOS && version >= 11.0) ||
      (Platform.isAndroid && version >= 7.0)) {
    arCompatible = true;
  }

  //request and check camera availability
  //check AR compatibility
  cameraAvailable = (await Permission.camera.request().isGranted);

  return cameraAvailable && arCompatible;
}
