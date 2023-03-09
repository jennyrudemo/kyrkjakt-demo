/*
* Copyright (c) 2021 Fei Alm, Jessie Chow, Anna Wästling, David Styrbjörn, Jenny Rudemo
* This source code is licensed under the MIT-style license found in the
* LICENSE file in the root directory of this source tree.
*
* @author Anna Wästling, Jessie Chow
* @date 2021-05-25
*
* @summary
* Makes a jigsaw puzzle with an image
*
* Based on "Building a Puzzle Game Using Flutter" by Dragos Holban 
* https://dragosholban.com/2019/02/16/building-a-puzzle-game-using-flutter/
*
* @structure
* Gets an image from the database and makes a jigsaw puzzle through puzzlePiece
*/

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kyrkjakt/config/color_config.dart';
import 'package:kyrkjakt/models/activity_model.dart';
import 'package:kyrkjakt/models/user_model.dart';
import 'package:kyrkjakt/widgets/clue_widget.dart';
import 'package:kyrkjakt/widgets/home_button_widget.dart';
import 'package:kyrkjakt/widgets/medium_text_icon_button.dart';
import 'package:kyrkjakt/widgets/puzzle_piece.dart';
import 'package:kyrkjakt/widgets/round_icon_button.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class PuzzleScreen extends StatefulWidget {
  @override
  _PuzzleScreenState createState() => _PuzzleScreenState();
  // Fields
  final VoidCallback skipCallback;
  final VoidCallback winCallback;
  final void Function(bool) letUserSkipCallback;

  // Constructor
  PuzzleScreen(this.winCallback, this.skipCallback, this.letUserSkipCallback);
}

class _PuzzleScreenState extends State<PuzzleScreen> {
  Image image;
  int rows;
  int cols;
  int numberOfPieces;
  int counter = 0;
  bool help = false;
  //List with pieces, gets it's pieces from puzzle_piece widget
  List<Widget> pieces = [];
  List<Widget> piecesCorrect = [];
  bool completedGame = false;
  String placeholderImage = "";

  // we need to find out the image size, to be used in the PuzzlePiece widget
  Future<Size> getImageSize(Image image) async {
    final Completer<Size> completer = Completer<Size>();
    //test
    image.image
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener(
      (ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      },
    ));
    final Size imageSize = await completer.future;
    return imageSize;
  }

  // Loads the puzzle and backdrop image from firebase storage
  void loadImages() async {
    var activity = Provider.of<ActivityModel>(context, listen: false);

    String placeholderURL = await firebase_storage.FirebaseStorage.instance
        .ref(activity.assets[3])
        .getDownloadURL();

    if (mounted) {
      setState(() {
        placeholderImage = placeholderURL;
      });
    }
  }

  void getRowsAndCols() {
    var activity = Provider.of<ActivityModel>(context, listen: false);
    numberOfPieces = activity.isEasy
        ? int.parse(activity.assets[0])
        : int.parse(activity.assets[1]);
    rows = cols = sqrt(numberOfPieces).toInt();
  }

  void puzzleFinished() {
    completedGame = true;
    // Put a delay on the complete so the user has a chance to see the finished puzzle
    new Future.delayed(const Duration(seconds: 2), widget.winCallback);
  }

  // here we will split the image into small pieces using the rows and columns defined above;
  // each piece will be added to a stack
  void splitImage() async {
    var activity = Provider.of<ActivityModel>(context, listen: false);
    Size imageSize;

    String puzzleURL = await firebase_storage.FirebaseStorage.instance
        .ref(activity.assets[2])
        .getDownloadURL();

    image = Image.network(puzzleURL);
    pieces.clear();
    imageSize = await getImageSize(image);

    for (int x = 0; x < rows; x++) {
      for (int y = 0; y < cols; y++) {
        pieces.add(PuzzlePiece(
          key: GlobalKey(),
          image: image,
          imageSize: imageSize,
          row: x,
          col: y,
          maxRow: rows,
          maxCol: cols,
          bringToTop: this.bringToTop,
          sendToBack: this.sendToBack,
        ));
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  // when the pan of a piece starts, we need to bring it to the front of the stack
  void bringToTop(Widget widget) {
    setState(() {
      pieces.remove(widget);
      pieces.add(widget);
    });
  }

  // when a piece reaches its final position, it will be sent to the back of the
  // stack to not get in the way of other, still movable, pieces
  void sendToBack(Widget widget) {
    setState(() {
      pieces.remove(widget);
      pieces.insert(0, widget);
      counter++;
      if (counter == numberOfPieces) {
        puzzleFinished();
      }
    });
  }

  void toggleHelp() {
    setState(() {
      help = !help;
    });
  }

  void getFactScreen() {
    Navigator.pushNamed(context, "/fact");
  }

  Widget topButtonSection() {
    if (completedGame) return Container();
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
        roundIconButton(
            Icons.info_outline, Colors.orange, getFactScreen, context),
        roundIconButton(Icons.help_outline, Colors.orange, toggleHelp, context)
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    // Stops memory leaks if the user "spams" activity skipped
    widget.letUserSkipCallback(false);
    loadImages();
    getRowsAndCols();
    splitImage();
    // Let the user skip this activity
    widget.letUserSkipCallback(true);
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserModel>(context, listen: false);
    double height = MediaQuery.of(context).size.height;
    Widget backdrop = LiquidCircularProgressIndicator();

    if (help) {
      return Clue(
        backdropColor: ColorConfig().darkPurple,
        goBackCallback: () {
          setState(() {
            help = false;
          });
        },
      );
    }

    if (placeholderImage.isNotEmpty) {
      backdrop = Image(
        alignment: Alignment.center,
        image: NetworkImage(placeholderImage),
        height: height,
      );
    }

    return Material(
      color: ColorConfig().darkPurple,
      child: Column(
        children: [
          Expanded(
            flex: 1,
            //place for topbuttons
            child: topButtonSection(),
          ),
          Expanded(
            flex: 4,
            child: Container(
              color: ColorConfig().darkPurple,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                    child: backdrop,
                  ),
                  Stack(children: pieces),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            //Skip button
            child: FractionallySizedBox(
              //changes the size of the button
              widthFactor: 0.6,
              heightFactor: 0.5,
              child: completedGame
                  ? Container()
                  : mediumTextIconButton(
                      user.languageMap["skip"][user.language],
                      Icons.fast_forward,
                      Colors.orange,
                      widget.skipCallback,
                      context),
            ),
          ),
        ],
      ),
    );
  }
}
