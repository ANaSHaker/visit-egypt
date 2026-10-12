import 'package:hive/hive.dart';

part 'favourite_event_model.g.dart';
@HiveType(typeId: 1)
class EventFav extends HiveObject{
  @HiveField(0)
  int? id;
  @HiveField(1)
  int? user_id;
  @HiveField(2)
  String? title;
  @HiveField(3)
  String? description;
  @HiveField(4)
  DateTime? startDate;
  @HiveField(5)
  DateTime? endDate;
  @HiveField(6)
  String? phone;
  @HiveField(7)
  String? websiteLink;
  @HiveField(8)
  String? email;
  @HiveField(9)
  int? payment;
  @HiveField(10)
  String? catergory;
  @HiveField(11)
  String? image;
  @HiveField(12)
  String? location;
  @HiveField(13)
  int? price;

  EventFav(
      {this.id,
      this.user_id,
      this.title,
      this.description,
      this.startDate,
      this.endDate,
      this.phone,
      this.websiteLink,
      this.email,
      this.payment,
      this.catergory,
      this.image,
      this.location,
      this.price});


}