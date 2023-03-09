/*
* Copyright (c) 2021 Fei Alm, Jessie Chow, Anna Wästling, David Styrbjörn, Jenny Rudemo
* This source code is licensed under the MIT-style license found in the
* LICENSE file in the root directory of this source tree.
*
* @author David Styrbjörn
* @date 2021-March
* @summary
* @structure:
*/

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  // Static instance created with the private constructor
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() =>
      _instance; // The public factory only returns our static instance

  // Named internal private constructor
  FirebaseService._internal();

  Future<QuerySnapshot> getAvailableChurchNames() async {
    // Query cloud firestore for the list of churches
    return FirebaseFirestore.instance
        .collection('utility') // Collection
        .where('available_churches') // Document
        .get(); // Returns Future<QuerySnapshot>
  }

  // Returns the correct data for the church model to be created with
  Future<QuerySnapshot> getCorrectChurchModel(String churchName) async {
    // Return the correct snapshot query of the church
    return FirebaseFirestore.instance
        .collection('churches')
        .where(FieldPath.documentId,
            isEqualTo:
                churchName) // Compare ID in documents that is equal to churchName
        .get();
  }
}
