// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'energy_unit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EnergyUnitAdapter extends TypeAdapter<EnergyUnit> {
  @override
  final int typeId = 3;

  @override
  EnergyUnit read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return EnergyUnit.kj;
      case 1:
        return EnergyUnit.cal;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, EnergyUnit obj) {
    switch (obj) {
      case EnergyUnit.kj:
        writer.writeByte(0);
        break;
      case EnergyUnit.cal:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnergyUnitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
