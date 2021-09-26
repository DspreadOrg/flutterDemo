import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_plugin_qpos/flutter_plugin_qpos.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_plugin_qpos');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('', () {
    StringBuffer buffer = new StringBuffer();

    String text = "4";


    buffer.write(listAddValue(int.parse(text)));

    buffer.write(listAddValue(0.toInt()));
    buffer.write(listAddValue(303.toInt()));
    buffer.write(listAddValue(107.toInt()));
    buffer.write(listAddValue(349.toInt()));
    print(buffer.toString());

    // var list =  new List<int>();
    // list.add(0);
    // list.add(1);
    // list.add(2);
    // list.add(3);
    // list = list.sublist(0,2);
    //
    //   print(int.parse("0D",radix: 16));
  });
}

String listAddValue(int value) {
  String reslut = "0000";
  String string = null;
  var list = new List<int>();
  list.add(value);
  var fromList = null;
  if(value >= 256){
    fromList =  Uint16List.fromList(list);
    string = Uint16ListToHexStr(fromList);
    return string;
  }else{
    fromList =  Uint8List.fromList(list);
    string = Uint8ListToHexStr(fromList);
    return reslut.substring(4 - string.length, 4) + string;
  }

}

String Uint16ListToHexStr(Uint16List list) {
  final String HEXES = "0123456789ABCDEF";
  if (list == null) {
    return null;
  }
  var hex = StringBuffer();
  for (int i = 0; i < list.length; i++) {
    hex.write(HEXES[((list[i] & 0xF000) >> 12)]);
    hex.write(HEXES[((list[i] & 0x0F00) >> 8)]);
    hex.write(HEXES[((list[i] & 0x00F0) >> 4)]);
    hex.write(HEXES[((list[i] & 0x000F))]);
  }
  return hex.toString();
}

String Uint8ListToHexStr(Uint8List list) {
  final String HEXES = "0123456789ABCDEF";
  if (list == null) {
    return null;
  }
  var hex = StringBuffer();

  for (int i = 0; i < list.length; i++) {
    hex.write(HEXES[((list[i] & 0xF0) >> 4)]);
    hex.write(HEXES[((list[i] & 0x0F))]);
  }
  return hex.toString();
}

methodHanshu1() async {
  await xunhuandaying("测试异步哈桑农户1111111");
}

xunhuandaying(String value) {
  var i = 100;
  while (i > 0) {
    print(value);

    i--;
  }
}

methodHanshu() async {
  await xunhuandaying("测试异步哈桑农户");
}
