// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crypto_currency_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CryptoCurrencyEntityAdapter extends TypeAdapter<CryptoCurrencyEntity> {
  @override
  final int typeId = 1;

  @override
  CryptoCurrencyEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CryptoCurrencyEntity(
      iconUrl: fields[0] as String,
      price: fields[1] as double,
      change: fields[2] as double,
      name: fields[3] as String,
      symbol: fields[4] as String,
      uuid: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CryptoCurrencyEntity obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.iconUrl)
      ..writeByte(1)
      ..write(obj.price)
      ..writeByte(2)
      ..write(obj.change)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.symbol)
      ..writeByte(5)
      ..write(obj.uuid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CryptoCurrencyEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
