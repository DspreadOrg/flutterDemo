import 'dart:typed_data';

class Utils {
  static String HEXES = "0123456789ABCDEF";

  static String Uint8ListToHexStr(Uint8List list) {
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

  static String Uint16ListToHexStr(Uint16List list) {
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

  static bool equals(String value, String other) {
    int n = other.length;
    if (n == value.length) {
      int i = 0;
      while (n-- != 0) {
        if (value.codeUnitAt(i) != other.codeUnitAt(i)) return false;
        i++;
      }
      return true;
    }
    return false;
  }
}
