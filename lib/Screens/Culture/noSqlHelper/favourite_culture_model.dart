import 'package:hive/hive.dart';

part 'favourite_culture_model.g.dart';
@HiveType(typeId: 2)
class DataFavCuluture extends HiveObject{
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? title;

  String? image;
  @HiveField(2)

  @HiveField(3)
  String? description;

  @HiveField(4)
  double? rate;

  @HiveField(5)
  String? link;
  @HiveField(6)
  String? mainCharacter;
  DataFavCuluture(
      {this.id,
        this.image,
        this.rate,
        this.title,
        this.description,
      this.link,
      this.mainCharacter});
}