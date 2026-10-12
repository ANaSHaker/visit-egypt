
part of 'favourite_company_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DataAdapter extends TypeAdapter<DataFav> {
  @override
  final int typeId = 0;

  @override
  DataFav read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DataFav(
      id: fields[0] as int?,
      image: fields[1] as String?,
      rate: fields[2] as int?,
      type: fields[3] as String?,
      websiteLink: fields[4] as String?,
      contactLink: fields[5] as String?,
      createdAt: fields[6] as String?,
      updatedAt: fields[7] as String?,
      name: fields[8] as String?,
      description: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DataFav obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.image)
      ..writeByte(2)
      ..write(obj.rate)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.websiteLink)
      ..writeByte(5)
      ..write(obj.contactLink)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt)
      ..writeByte(8)
      ..write(obj.name)
      ..writeByte(9)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is DataAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}