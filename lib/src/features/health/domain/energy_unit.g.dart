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
        return EnergyUnit.kilojoules;
      case 1:
        return EnergyUnit.calories;
      default:
        return EnergyUnit.kilojoules;
    }
  }

  @override
  void write(BinaryWriter writer, EnergyUnit obj) {
    switch (obj) {
      case EnergyUnit.kilojoules:
        writer.writeByte(0);
        break;
      case EnergyUnit.calories:
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
