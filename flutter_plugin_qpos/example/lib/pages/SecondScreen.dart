import 'package:flutter/material.dart';
import 'package:flutter_plugin_qpos_example/keyboard/view_keyboard.dart';
import 'package:toast/toast.dart';

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final String paras =ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("Second Screen"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            _showKeyboard(context);
          },
          child: Text("back"),
        ),
      ),
    );
  }

  void _showKeyboard(BuildContext context) {
  var  keylist =  [
      "1",
      "2",
      "3",
      "4",
      "5",
      "6",
      "7",
      "8",
      "9",
      "14",
      "0",
      "15",
      "13"
    ];
    for(int i=0;i<keylist.length;i++){
      if(keylist[i] == "13"){
        keylist[i] = "cancel";
      }else if(keylist[i] == "14"){
        keylist[i] = "del";
      }
      else if(keylist[i] == "15"){
        keylist[i] = "confirm";
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (builder) {
        return CustomKeyboard(
          initEvent: (value) {
            print(value);

          },
          callback: (keyEvent) {
            if (keyEvent.isClose()) {
              print("POS keyEvent.isClose()");
              Navigator.pop(context);
            }
          },
          keyList: keylist,
          keyHeight: 46,
          autoBack: false,
          onResult: (data) {
            Toast.show("POS onResult" + data, context,
                duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
          },
        );
      },
    );
  }
}
