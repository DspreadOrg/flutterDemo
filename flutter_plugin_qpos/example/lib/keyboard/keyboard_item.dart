import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_plugin_qpos_example/Utils.dart';

class KeyboardItem extends StatefulWidget {
  final String text;
  final callback;
  final drowEvent;
  final double keyHeight;
  final double keyWidth;
  final double parentHeight;

  const KeyboardItem(
      {Key key, this.drowEvent, this.callback, this.text, this.keyHeight,this.keyWidth,this.parentHeight})
      : super(key: key);

  @override
  ButtonState createState() => ButtonState();
}

class ButtonState extends State<KeyboardItem> {
  var backMethod;
  double keyHeight = 44;
  double keyWidth = 120;
  double txtSize = 18;
  String text;
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

    var _screenWidth = mediaQuery.size.width;
    // 监听widget渲染完成
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      if(processOnce){
        return;
      }
      processOnce = true;
      RenderBox renderBox = anchorKey.currentContext.findRenderObject();
      var offset = renderBox.localToGlobal(Offset.zero);
      double lx = offset.dx;
      double ly = offset.dy-widget.parentHeight;
      double rx = offset.dx + _screenWidth / 3;
      double ry = offset.dy-widget.parentHeight+widget.keyHeight;
      print("KeyLiftTopPointX:" +
          lx.toStringAsFixed(0) +
          "   KeyLiftTopPointY:" +
          ly.toStringAsFixed(0) +
          "   KeyRightBomPointX:" +
          rx.toStringAsFixed(0) +
          "   KeyRightBomPointY:" +
          ry.toStringAsFixed(0) +
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
      buffer.write(listAddValue((lx*1.5).toInt()));
      buffer.write(listAddValue((ly*1.5).toInt()));
      buffer.write(listAddValue((rx*1.5).toInt()));
      buffer.write(listAddValue((ry*1.5).toInt()));
      widget.drowEvent(buffer.toString());
    });


    if (null != widget.keyHeight) {
      keyHeight = widget.keyHeight;
    }
    if (null != widget.keyWidth) {
      keyWidth = widget.keyWidth;
    }else{
      keyWidth = _screenWidth / 3;
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
            child: OutlineButton(
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
    String string = null;
    var list = new List<int>();
    list.add(value);
    var fromList = null;
    if(value >= 256){
      fromList =  Uint16List.fromList(list);
      string = Utils.Uint16ListToHexStr(fromList);
      return string;
    }else{
      fromList =  Uint8List.fromList(list);
      string = Utils.Uint8ListToHexStr(fromList);
      return reslut.substring(4 - string.length, 4) + string;
    }

  }
}
