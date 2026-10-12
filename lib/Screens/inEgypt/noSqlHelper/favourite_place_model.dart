import 'package:hive/hive.dart';

part 'favourite_place_model.g.dart';
@HiveType(typeId: 4)
class DataFavPlaces extends HiveObject{
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? image;
  @HiveField(3)
  String? description;
  @HiveField(4)
  double? rate;
  @HiveField(5)
  String? location;
  @HiveField(6)
  String? website;
  @HiveField(7)
  String? phone;
  DataFavPlaces(
      {this.id,
        this.image,
        this.rate,
        this.name,
        this.description,
      this.location,
      this.website,
      this.phone});
}