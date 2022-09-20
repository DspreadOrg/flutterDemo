import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_qpos/flutter_plugin_qpos.dart';

class SecondPage extends StatelessWidget{
  FlutterPluginQpos pluginQpos;
  SecondPage(this.pluginQpos);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('The second page now'),),
      body:new ListView(
          children: [
        Center(child: ElevatedButton(
        child: Text('Return'),
        onPressed: (){
          Navigator.pop(context);
        },
      ),),
         ElevatedButton(
          onPressed: () async {
            pluginQpos.getQposId();
          },
          child: Text("get id"),
        ),
          ]
    ));
  }

}