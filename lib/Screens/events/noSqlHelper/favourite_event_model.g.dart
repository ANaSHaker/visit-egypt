// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favourite_event_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DataEventAdapter extends TypeAdapter<EventFav> {
  @override
  final int typeId = 1;

  @override
  EventFav read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EventFav(
      id: fields[0] as int?,
      user_id: fields[1] as int?,
      title: fields[2] as String?,
      description: fields[3] as String?,
      startDate: fields[4] as DateTime?,
      endDate: fields[5] as DateTime?,
      phone: fields[6] as String?,
      websiteLink: fields[7] as String?,
      email: fields[8] as String?,
      payment: fields[9] as int?,
      catergory: fields[10] as String?,
      image: fields[11] as String?,
      location: fields[12] as String?,
      price: fields[13] as int?,

    );
  }

  @override
  void write(BinaryWriter writer, EventFav obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.user_id)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.startDate)
      ..writeByte(5)
      ..write(obj.endDate)
      ..writeByte(6)
      ..write(obj.phone)
      ..writeByte(7)
      ..write(obj.websiteLink)
      ..writeByte(8)
      ..write(obj.email)
      ..writeByte(9)
      ..write(obj.payment)
      ..writeByte(10)
      ..write(obj.catergory)
      ..writeByte(11)
      ..write(obj.image)
      ..writeByte(12)
      ..write(obj.location)
      ..writeByte(13)
      ..write(obj.price);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataEventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
