import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeModeAdapter extends TypeAdapter<ThemeMode?> {
  @override
  final typeId = 5;

  @override
  ThemeMode? read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ThemeMode.light;
      case 1:
        return ThemeMode.dark;
      case 2:
        return ThemeMode.system;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, ThemeMode? obj) {
    switch (obj) {
      case ThemeMode.light:
        writer.writeByte(0);
        break;
      case ThemeMode.dark:
        writer.writeByte(1);
        break;
      case ThemeMode.system:
        writer.writeByte(2);
        break;
      default:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ThemeModeAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
