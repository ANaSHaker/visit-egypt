
part of 'favourite_place_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DataAdapterPlaces extends TypeAdapter<DataFavPlaces> {
  @override
  final int typeId = 4;

  @override
  DataFavPlaces read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DataFavPlaces(
      id: fields[0] as int?,
      name: fields[1] as String?,
      image: fields[2] as String?,
      description: fields[3] as String?,
      rate: fields[4] as double?,
      location: fields[5] as String?,
      website: fields[6] as String?,
      phone: fields[7] as String?,

    );
  }

  @override
  void write(BinaryWriter writer, DataFavPlaces obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.rate)
      ..writeByte(5)
      ..write(obj.location)
      ..writeByte(6)
      ..write(obj.website);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is DataAdapterPlaces &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}