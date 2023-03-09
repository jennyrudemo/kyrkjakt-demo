/*
* Copyright (c) 2021 Fei Alm, Jessie Chow, Anna Wästling, David Styrbjörn, Jenny Rudemo
* This source code is licensed under the MIT-style license found in the
* LICENSE file in the root directory of this source tree.
*
* @author David Styrbjörn
* @date 
*
* @summary
* Content model, used to represent factoids + news entries
*
* @structure
* Initialises the members with data from the database
*/

class ContentModel {
  // Members
  String titleSwe;
  String contentSwe;

  // Constructor
  ContentModel({
    this.titleSwe,
    this.contentSwe,
  });

  // See church_model.dart for use-case
  factory ContentModel.fromJson(Map<String, dynamic> json) => ContentModel(
        titleSwe: json["title_swe"],
        contentSwe: json["content_swe"],
      );
}
