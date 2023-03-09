/*
* Copyright (c) 2021 Fei Alm, Jessie Chow, Anna Wästling, David Styrbjörn, Jenny Rudemo
* This source code is licensed under the MIT-style license found in the
* LICENSE file in the root directory of this source tree.
*
* @author Anna Wästling, Jenny Rudemo, Jessie Chow, David Styrbjörn
* @date 2021-05-25
* @summary
* Makes a jigsaw puzzle with an image
* 
* Based on "Building a Puzzle Game Using Flutter" by Dragos Holban 
* https://dragosholban.com/2019/02/16/building-a-puzzle-game-using-flutter/
*
* @structure
* Splits the image into jigsaw puzzle pieces and the position of the pieces
*/

import 'dart:math';
import 'package:flutter/material.dart';

//Puzzlepiece is a class thast holds the value to make a puzzlepiece
class PuzzlePiece extends StatefulWidget {
  final Image image;
  final Size imageSize;
  final int row;
  final int col;
  final int maxRow;
  final int maxCol;
  final Function bringToTop;
  final Function sendToBack;

  PuzzlePiece({
    Key key,
    @required this.image,
    @required this.imageSize,
    @required this.row,
    @required this.col,
    @required this.maxRow,
    @required this.maxCol,
    @required this.bringToTop,
    @required this.sendToBack,
  }) : super(key: key);

  @override
  PuzzlePieceState createState() {
    return new PuzzlePieceState();
  }
}

class PuzzlePieceState extends State<PuzzlePiece> {
  //top is the position of the top of any puzzlepiece
  //left is the position of the left of any puzzlepiece
  double top;
  double left;
  //Used when piece is at right location
  bool isMovable = true;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double imHeight = widget.imageSize.height;
    double imWidth = widget.imageSize.width;
    double scale = 2 / 3;
    double centerWidth = width / 2; //center pixel value width-vise
    double centerHeight = height / 2; //center pixel value height-vise

    // Used to prevent the pieces from being placed "outside" of the screen
    var widthFactor = 80.0; //Based on an estimation on the piece's width
    var heightFactor = 40.0; //Based on an estimation on the piece's height
    var topMargin = 5.0;

    // Randomize the top and left starting point of each piece
    // Coordinates are given in local coordinate system
    if (top == null) {
      top = -Random().nextDouble() * heightFactor * widget.row;
      top += topMargin; //Add margin between pieces and top of puzzle window
    }
    if (left == null) {
      var offset = -Random().nextDouble() * widthFactor * widget.col;
      //Offset the left edge
      left = offset;
      var bulgeWidth = 60.0; //True for iPhone 6s
      //Check if the bulge is outside of the screen
      if (left < offset + bulgeWidth) {
        left = left + bulgeWidth;
      }
    }

    //Positions the pieces of the puzzle
    Positioned correctPosition() {
      double scaleW;
      double scaleH;
      double correctTop;
      double correctLeft;

      //Poisitions the puzzle depending on the image's rotation
      if (imWidth > imHeight) {
        //horizontally rotated image
        scaleW = 0.9 * width;
        scaleH = null;
      } else {
        //vertically rotated image
        scaleH = height * scale;
        scaleW = null;
      }
      return Positioned(
        top: top,
        left: left,
        width: scaleW,
        height: scaleH,
        child: GestureDetector(
          //if a piece is touched, move the piece to the front of the stack
          onTap: () {
            if (isMovable) {
              widget.bringToTop(widget);
            }
          },
          onPanStart: (_) {
            if (isMovable) {
              widget.bringToTop(widget);
            }
          },
          //When the piece is dragged
          onPanUpdate: (dragUpdateDetails) {
            // if the piece is not set at its place
            if (isMovable) {
              setState(() {
                //Update top and lefts position
                top += dragUpdateDetails.delta.dy;
                left += dragUpdateDetails.delta.dx;

                //Compute the width of the actual puzzle (the scaled image)
                var puzzleWidth = context.size.width;
                var puzzleHeight = context.size.height;
                //Compute the size of each puzzle piece
                var pieceWidth = puzzleWidth / widget.maxCol;
                var pieceHeight = puzzleHeight / widget.maxRow;

                /* The correctPosition (left most coordinate) will be calculated as an
                 offset from the middle of the screen, that depends on which column the
                 piece is in
                 (-widget.maxCol + 2 * widget.col) * pieceWidth / 2 does that calculation
                 For example, if there are three columns, the piece in the middle column
                 (1) should be positioned with its left edge half its own width from the
                 middle.
                 To "reset" the internal coordinat system and correct position
                 start at (0,0), the number of columns is multiplies with the
                 width of the piece and subtracted */

                correctLeft = centerWidth +
                    (-widget.maxCol + 2 * widget.col) * pieceWidth / 2 -
                    widget.col * pieceWidth;

                correctTop = centerHeight * scale +
                    (-widget.maxRow + 2 * widget.row) * pieceHeight / 2 -
                    widget.row * pieceHeight;

                if (correctTop - 5 < top &&
                    top < correctTop + 5 &&
                    correctLeft - 5 < left &&
                    left < correctLeft + 5) {
                  top = correctTop;
                  left = correctLeft;
                  print(left);

                  //Piece is at correct loaction
                  isMovable = false;
                  widget.sendToBack(widget);
                }
              });
            }
          },
          child: ClipPath(
            child: CustomPaint(
                foregroundPainter: PuzzlePiecePainter(
                    widget.row, widget.col, widget.maxRow, widget.maxCol),
                child: widget.image),
            clipper: PuzzlePieceClipper(
                widget.row, widget.col, widget.maxRow, widget.maxCol),
          ),
        ),
      );
    }

    return correctPosition();
  }
}

// Clips the image to the puzzle piece path
class PuzzlePieceClipper extends CustomClipper<Path> {
  final int row;
  final int col;
  final int maxRow;
  final int maxCol;

  PuzzlePieceClipper(this.row, this.col, this.maxRow, this.maxCol);

  @override
  Path getClip(Size size) {
    return getPiecePath(size, row, col, maxRow, maxCol);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// Draws a border around the clipped image
class PuzzlePiecePainter extends CustomPainter {
  final int row;
  final int col;
  final int maxRow;
  final int maxCol;

  PuzzlePiecePainter(this.row, this.col, this.maxRow, this.maxCol);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white.withOpacity(0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawPath(getPiecePath(size, row, col, maxRow, maxCol), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

// Path used to clip the image and, then, to draw a border around it; here we actually draw the puzzle piece
Path getPiecePath(Size size, int row, int col, int maxRow, int maxCol) {
  final width = size.width / maxCol;
  final height = size.height / maxRow;
  final offsetX = col * width;
  final offsetY = row * height;
  final bumpSize = height / 4;

  var path = Path();
  path.moveTo(offsetX, offsetY);

  if (row == 0) {
    // top side piece
    path.lineTo(offsetX + width, offsetY);
  } else {
    // top bump
    path.lineTo(offsetX + width / 3, offsetY);
    path.cubicTo(
        offsetX + width / 6,
        offsetY - bumpSize,
        offsetX + width / 6 * 5,
        offsetY - bumpSize,
        offsetX + width / 3 * 2,
        offsetY);
    path.lineTo(offsetX + width, offsetY);
  }

  if (col == maxCol - 1) {
    // right side piece
    path.lineTo(offsetX + width, offsetY + height);
  } else {
    // right bump
    path.lineTo(offsetX + width, offsetY + height / 3);
    path.cubicTo(
        offsetX + width - bumpSize,
        offsetY + height / 6,
        offsetX + width - bumpSize,
        offsetY + height / 6 * 5,
        offsetX + width,
        offsetY + height / 3 * 2);
    path.lineTo(offsetX + width, offsetY + height);
  }

  if (row == maxRow - 1) {
    // bottom side piece
    path.lineTo(offsetX, offsetY + height);
  } else {
    // bottom bump
    path.lineTo(offsetX + width / 3 * 2, offsetY + height);
    path.cubicTo(
        offsetX + width / 6 * 5,
        offsetY + height - bumpSize,
        offsetX + width / 6,
        offsetY + height - bumpSize,
        offsetX + width / 3,
        offsetY + height);
    path.lineTo(offsetX, offsetY + height);
  }

  if (col == 0) {
    // left side piece
    path.close();
  } else {
    // left bump
    path.lineTo(offsetX, offsetY + height / 3 * 2);
    path.cubicTo(
        offsetX - bumpSize,
        offsetY + height / 6 * 5,
        offsetX - bumpSize,
        offsetY + height / 6,
        offsetX,
        offsetY + height / 3);
    path.close();
  }

  return path;
}
