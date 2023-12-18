// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forex_currency_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ForexCurrencyEntityAdapter extends TypeAdapter<ForexCurrencyEntity> {
  @override
  final int typeId = 2;

  @override
  ForexCurrencyEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ForexCurrencyEntity(
      code: fields[0] as String,
      name: fields[1] as String,
      flag: fields[2] as String,
      symbol: fields[3] as String,
      rate: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ForexCurrencyEntity obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.code)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.flag)
      ..writeByte(3)
      ..write(obj.symbol)
      ..writeByte(4)
      ..write(obj.rate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ForexCurrencyEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
