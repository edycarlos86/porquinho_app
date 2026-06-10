// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'porquinho_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PorquinhoAdapter extends TypeAdapter<Porquinho> {
  @override
  final int typeId = 0;

  @override
  Porquinho read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Porquinho(
      id: fields[0] as String,
      nome: fields[1] as String,
      meta: fields[2] as double,
      depositoMaximo: fields[3] as int,
      depositosFeitos: (fields[4] as List).cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, Porquinho obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nome)
      ..writeByte(2)
      ..write(obj.meta)
      ..writeByte(3)
      ..write(obj.depositoMaximo)
      ..writeByte(4)
      ..write(obj.depositosFeitos);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PorquinhoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
