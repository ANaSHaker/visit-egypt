import 'package:hive/hive.dart';

part 'favourite_company_model.g.dart';
@HiveType(typeId: 0)
class DataFav extends HiveObject{
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? image;
  @HiveField(2)
  int? rate;
  @HiveField(3)
  String? type;
  @HiveField(4)
  String? websiteLink;
  @HiveField(5)
  String? contactLink;
  @HiveField(6)
  String? createdAt;
  @HiveField(7)
  String? updatedAt;
  @HiveField(8)
  String? name;
  @HiveField(9)
  String? description;

  DataFav(
      {this.id,
        this.image,
        this.rate,
        this.type,
        this.websiteLink,
        this.contactLink,
        this.createdAt,
        this.updatedAt,
        this.name,
        this.description,});
}