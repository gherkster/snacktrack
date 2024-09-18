// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'energy.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EnergyAdapter extends TypeAdapter<Energy> {
  @override
  final int typeId = 1;

  @override
  Energy read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Energy(
      fields[0] as double,
      fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Energy obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.energy)
      ..writeByte(1)
      ..write(obj.time);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnergyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
