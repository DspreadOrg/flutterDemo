import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_qpos_example/keyboard/view_pwdfield.dart';

import 'key_event.dart';
import 'keyboard_item.dart';

class CustomKeyboard extends StatefulWidget {
  final callback;
  final initEvent;
  final onResult;
  final autoBack;
  final double keyHeight;
  final int pwdField;
  final List<String> keyList;

  const CustomKeyboard(

      {this.callback,
        this.pwdField,
      this.initEvent,
      this.onResult,
      this.autoBack = false,
      this.keyHeight = 48,
      this.keyList});

  @override
  _CustomKeyboardState createState() => _CustomKeyboardState();
}

class _CustomKeyboardState extends State<CustomKeyboard> {
  String data = "";
  var _screenWidth;
  var _screenHeight;

  StringBuffer buffer =  new StringBuffer();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    MediaQueryData mediaQuery = MediaQuery.of(context);

    _screenHeight = mediaQuery.size.height;
      _screenWidth = mediaQuery.size.width;
      print("MediaQueryData   "+"_screenHeight:"+_screenHeight.toString()+"_screenWidth:"+_screenWidth.toString());
      print("CustomKeyboard   "+"height:"+(5 * widget.keyHeight+180).toString()+"_screenWidth:"+_screenWidth.toString());
    return Container(
      height: 5 * widget.keyHeight,
      width: double.infinity,
      color: Colors.transparent,

      child: Column(
        children: <Widget>[
          // pwdWidget(),
          keyboardWidget(),
        ],
      ),
    );
  }

  Widget pwdWidget() {
    return Container(
      width: double.infinity,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      margin: EdgeInsets.all(20),
      child: Stack(
        children: <Widget>[
          Align(
            child: IconButton(
              icon: Icon(Icons.close, size: 28),
              onPressed: () => widget.callback(KeyDownEvent("close")),
            ),
            alignment: Alignment.topRight,
          ),
          Container(
            width: double.infinity,
            height: 140,
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "请输入支付密码",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Container(
                  width: 250,
                  height: 40,
                  margin: EdgeInsets.only(top: 10),
                  child: CustomPwdField(getPinField()),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget keyboardWidget() {
    print("keyboardWidget:build");

    return Container(
      width: double.infinity,
      color: Colors.white,
      height: 5 * widget.keyHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[normalWidget(), botomWidget()],
      ),
    );
  }

  void onKeyDown(BuildContext context, String text) {
    if ("confirm" == text) {
      widget.onResult(data);
      widget.callback(KeyDownEvent("close"));
      return;
    }
    if ("cancel" == text) {
      widget.callback(KeyDownEvent("close"));
      return;
    }
    if ("del" == text && data.length > 0) {
      setState(() {
        data = data.substring(0, data.length - 1);
      });
    }
    if (data.length >= 6) {
      return;
    }
    setState(() {
      if ("del" != text && text != "commit") {
        data += text;
      }
    });
    if (data.length == 6 && widget.autoBack) {
      widget.onResult(data);
    }
  }

  normalWidget() {
    print("normalWidget:build");
    return Container(
      width: double.infinity,
      color: Colors.white,
      height: 3 * widget.keyHeight,
      child: Wrap(
        children: widget.keyList.sublist(0,9).map((item) {
          var keyboardItem = KeyboardItem(
              parentHeight:5 * widget.keyHeight,
            drowEvent: (value) => onDrowKeyMap(value),
            keyHeight: widget.keyHeight,
            text: item,
            callback: (val) => onKeyDown(context, item),
          );
          return keyboardItem;
        }).toList(),
      ),
    );
  }

  botomWidget() {
    print("botomWidget:build");

    return Container(
      width: double.infinity,
      color: Colors.white,
      height: 2 * widget.keyHeight,
      child:  Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: KeyboardItem(
              parentHeight:5 * widget.keyHeight,

              drowEvent: (value) => onDrowKeyMap(value),
              keyHeight: widget.keyHeight*2,
              text: widget.keyList[9],
              callback: (val) => onKeyDown(context, widget.keyList[9]),
            ),
          ),
          Positioned(
            top: 0,
            left: _screenWidth/3,
            child: KeyboardItem(
              parentHeight:5 * widget.keyHeight,

              drowEvent: (value) => onDrowKeyMap(value),
              keyHeight: widget.keyHeight,
              text: widget.keyList[10],
              callback: (val) => onKeyDown(context, widget.keyList[10]),
            ),
          ),

          Positioned(
            top: widget.keyHeight,
            left: _screenWidth/3,
            child: KeyboardItem(
              parentHeight:5 * widget.keyHeight,

              drowEvent: (value) => onDrowKeyMap(value),
              keyHeight: widget.keyHeight,
              text: widget.keyList[11],
              callback: (val) => onKeyDown(context, widget.keyList[11]),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: KeyboardItem(
              parentHeight:5 * widget.keyHeight,

              drowEvent: (value) => onDrowKeyMap(value),
              keyHeight: widget.keyHeight*2,
              text: widget.keyList[12],
              callback: (val) => onKeyDown(context, widget.keyList[12]),
            ),
          ),
        ],
      ),
    );
  }

  onDrowKeyMap(value) {
    buffer.write(value);
    var len1 = buffer.length;
    var len2 = widget.keyList.length*20;
    if(len1 == len2){
      widget.initEvent(buffer.toString());
    }
  }

  String getPinField() {
    if(widget.pwdField == null)
      return data;
    if(widget.pwdField == -1){
      Navigator.pop(context);
    }
    StringBuffer result = new StringBuffer();
    for(int i =0;i< widget.pwdField ;i++){
      result.write(i);
    }
    return result.toString();
  }
}