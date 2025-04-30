// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'material_usage.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MaterialUsageAdapter extends TypeAdapter<MaterialUsage> {
  @override
  final int typeId = 2;

  @override
  MaterialUsage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MaterialUsage(
      id: fields[0] as String,
      materialId: fields[1] as String,
      quantityUsed: fields[2] as double,
      timestamp: fields[3] as DateTime,
      operatorId: fields[4] as String,
      operationId: fields[5] as String,
      totalCost: fields[6] as double,
    );
  }

  @override
  void write(BinaryWriter writer, MaterialUsage obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.materialId)
      ..writeByte(2)
      ..write(obj.quantityUsed)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.operatorId)
      ..writeByte(5)
      ..write(obj.operationId)
      ..writeByte(6)
      ..write(obj.totalCost);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MaterialUsageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
