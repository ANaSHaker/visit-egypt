
part of 'favourite_culture_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DataAdapterCuluture extends TypeAdapter<DataFavCuluture> {
  @override
  final int typeId = 2;

  @override
  DataFavCuluture read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DataFavCuluture(
      id: fields[0] as int?,
      title: fields[1] as String?,
      description: fields[2] as String?,
      image: fields[3] as String?,
      rate: fields[4] as double?,
      link: fields[5] as String?,
      mainCharacter: fields[6] as String?,

    );
  }

  @override
  void write(BinaryWriter writer, DataFavCuluture obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.rate)
      ..writeByte(5)
      ..write(obj.link)
      ..writeByte(6)
      ..write(obj.mainCharacter);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is DataAdapterCuluture &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}