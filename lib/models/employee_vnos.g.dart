// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_vnos.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VnosAdapter extends TypeAdapter<Vnos> {
  @override
  final int typeId = 0;

  @override
  Vnos read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Vnos(
      name: fields[0] as String,
      surname: fields[1] as String,
      workplaceIndex: fields[3] as int,
      email: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Vnos obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.surname)
      ..writeByte(3)
      ..write(obj.workplaceIndex)
      ..writeByte(4)
      ..write(obj.email);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VnosAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
