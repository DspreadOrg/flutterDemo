import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_plugin_qpos_example/Utils.dart';

class KeyboardItem extends StatefulWidget {
  final String text;
  final callback;
  final drowEvent;
  final double keyHeight;
  final double? keyWidth;
  final double parentHeight;
  final int index;

  const KeyboardItem(
      {Key? key, this.drowEvent, this.callback, required this.text, required this.keyHeight, this.keyWidth,required this.parentHeight,this.index = 0})
      : super(key: key);

  @override
  ButtonState createState() => ButtonState();
}

class ButtonState extends State<KeyboardItem> {
  var backMethod;
  double keyHeight = 46;
  double keyWidth = 120;
  double txtSize = 18;
  late String text;
  GlobalKey anchorKey = GlobalKey();

  bool processOnce = false;

  void onTap() {
    widget.callback("$backMethod");
  }

  @override
  void initState() {
    super.initState();
    text = widget.text;
    if (text == "cancel") {

      txtSize = 16;
    } else if (text == "del") {
      txtSize = 16;

    }
    else if (text == "confirm") {
      txtSize = 16;

    } else {
      txtSize = 18;
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    var screenWidth = mediaQuery.size.width;
    var screenHeight = mediaQuery.size.height;
    var devicePixelRatio = mediaQuery.devicePixelRatio;
    var keyHeight = widget.keyHeight;
    var keyboardKeyIndex = widget.index;
    //行数
    int rows = ((keyboardKeyIndex+2)/3 - 1).toInt();
    //列数
    int columns = (keyboardKeyIndex - (rows * 3 + 1)).toInt();
    print("rows: " + rows.toString());
    print("columns: " + columns.toString());
    // 监听widget渲染完成
    double leftTopPointX = 0;
    double leftTopPointY = 0;
    double rightBottomPointX = 0;
    double rightBottomPointY = 0;

    leftTopPointX = (screenWidth * devicePixelRatio)/3 * columns;
    leftTopPointY = (screenHeight - keyHeight*5) * devicePixelRatio + keyHeight * devicePixelRatio * rows;
    rightBottomPointX = leftTopPointX + (screenWidth * devicePixelRatio)/3;
    rightBottomPointY = leftTopPointY + keyHeight *devicePixelRatio;

    if (keyboardKeyIndex == 10 || keyboardKeyIndex == 12){
      rightBottomPointY = leftTopPointY + keyHeight *devicePixelRatio * 2;
    }
    print("leftTopPointX:" +
          leftTopPointX.toStringAsFixed(0) +
          "   leftTopPointY:" +
          leftTopPointY.toStringAsFixed(0) +
          "   rightBottomPointX:" +
          rightBottomPointX.toStringAsFixed(0) +
          "   rightBottomPointY:" +
          rightBottomPointY.toStringAsFixed(0) +
          "   value" +
          text);

    StringBuffer buffer = new StringBuffer();
    if (text == "confirm") {
      buffer.write(listAddValue(15));
    } else if (text == "del") {
      buffer.write(listAddValue(14));
    } else if (text == "cancel") {
      buffer.write(listAddValue(13));
    } else {
      buffer.write(listAddValue(int.parse(text)));
    }
    buffer.write(listAddValue((leftTopPointX).toInt()));
    buffer.write(listAddValue((leftTopPointY).toInt()));
    buffer.write(listAddValue((rightBottomPointX).toInt()));
    buffer.write(listAddValue((rightBottomPointY).toInt()));
    widget.drowEvent(buffer.toString());

    if (null != widget.keyHeight) {
      keyHeight = widget.keyHeight;
    }
    if (null != widget.keyWidth) {
      keyWidth = widget.keyWidth!;
    }else{
      keyWidth = screenWidth / 3;
    }
    return Container(
      height: keyHeight,
      width: keyWidth,
      key: anchorKey,
      child:
      Stack(
        children: <Widget>[
          // Positioned(
          //   top: 0,
          //   left: 0,
          //   child: Container(
          //     color: Colors.blue,
          //     child: Text(
          //       "Left",
          //       style: TextStyle(
          //         fontWeight: FontWeight.bold,
          //         fontSize: 5,
          //       ),
          //     ),
          //   ),
          // ),
          Positioned(
            bottom: 0,
            right: 0,
            top: 0,
            left: 0,
            child: OutlinedButton(
              onPressed: onTap,
              child: Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: txtSize,
                ),
              ),
            ),
          ),
          // Positioned(
          //   bottom: 0,
          //   right: 0,
          //   child: Container(
          //     color: Colors.red,
          //     child: Text(
          //       "Right",
          //       style: TextStyle(
          //         fontWeight: FontWeight.bold,
          //         fontSize: 5,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),

      // OutlineButton(
      //   onPressed: onTap,
      //   child: Text(
      //     text,
      //     key: anchorKey,
      //     style: TextStyle(
      //       fontWeight: FontWeight.bold,
      //       fontSize: txtSize,
      //     ),
      //   ),
      // ),
    );
  }

  String listAddValue(int value) {
    String reslut = "0000";
    String string = "";
    var list = new List<int>.empty(growable:true);
    list.add(value);
    var fromList = null;
    if(value >= 256){
      fromList =  Uint16List.fromList(list);
      string = Utils.Uint16ListToHexStr(fromList)!;
      return string;
    }else{
      fromList =  Uint8List.fromList(list);
      string = Utils.Uint8ListToHexStr(fromList)!;
      return reslut.substring(4 - string.length, 4) + string;
    }

  }
}
