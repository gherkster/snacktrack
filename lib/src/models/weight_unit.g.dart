// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weight_unit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeightUnitAdapter extends TypeAdapter<WeightUnit> {
  @override
  final int typeId = 4;

  @override
  WeightUnit read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return WeightUnit.kg;
      case 1:
        return WeightUnit.lb;
      default:
        return WeightUnit.kg;
    }
  }

  @override
  void write(BinaryWriter writer, WeightUnit obj) {
    switch (obj) {
      case WeightUnit.kg:
        writer.writeByte(0);
        break;
      case WeightUnit.lb:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeightUnitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
