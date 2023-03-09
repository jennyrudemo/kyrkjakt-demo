/*
* Copyright (c) 2021 Fei Alm, Jessie Chow, Anna Wästling, David Styrbjörn, Jenny Rudemo
* This source code is licensed under the MIT-style license found in the
* LICENSE file in the root directory of this source tree.
*
* @author David Styrbjörn, Anna Wästling, Jessie Chow
* @date 2021-05-07

* @summary
* Handles text to speech
*
* @structure: 
* Widget to be called for when using text to speech. Creates a button 
* that speak the string that gets inserted. Used by importing and calling the class with input string. 
*/

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechButton extends StatefulWidget {
  @override
  TextToSpeechButtonState createState() => TextToSpeechButtonState();
  //Text that should be read
  final String readUp;

  // Constructor
  TextToSpeechButton({this.readUp});
}

//Used to make a round button that activates text to speech
//Is called in the widget textSection
class TextToSpeechButtonState extends State<TextToSpeechButton> {
  //Not playing if not pressed
  bool isPlaying = false;
  //Initialise tts type
  FlutterTts _flutterTts;
  @override
  Widget build(BuildContext context) {
    return Container(
      //Sets the size of the button
      height: 40,
      //Sets the appearance of the button
      decoration: BoxDecoration(
        color: Colors.orange, //Sets the color of the button
        shape: BoxShape.circle, //Sets the shape of the button
        boxShadow: [
          //Sets a shadow on the button
          BoxShadow(
            blurRadius: 4,
            offset: Offset(4, 2),
            color: Colors.black.withOpacity(0.35),
          ),
        ],
      ),
      child: IconButton(
        padding: EdgeInsets.all(0.0),
        icon: Icon(Icons.volume_up), //Sets the icon of the button
        color: Colors.white, //Sets the color of the icon
        //Calling function speak when button is pressed
        onPressed: () {
          _speak(widget.readUp);
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initializeTts();
  }

  initializeTts() {
    //calling default constructor
    _flutterTts = FlutterTts();

    //Handles the state of the button at start
    _flutterTts.setStartHandler(() {
      setState(() {
        // Sound is playing
        isPlaying = true;
      });
    });
    //Handles the state of the button when finished
    _flutterTts.setCompletionHandler(() {
      setState(() {
        // Sound stops
        isPlaying = false;
      });
    });

    //Handles error, for debug purposes
    _flutterTts.setErrorHandler((err) {
      setState(() {
        print("error occurred: " + err);
        isPlaying = false;
      });
    });
  }

//Start speaking, called for when button is pressed
  Future _speak(String text) async {
    // checks if there is a string that is not empty
    if (text != null && text.isNotEmpty) {
      // Function call for function in flutter_tts
      //that returns 1 when speaking
      var result = await _flutterTts.speak(text);
      // While result is 1 continue playing
      if (result == 1)
        setState(() {
          isPlaying = true;
        });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _flutterTts.stop();
  }
}
