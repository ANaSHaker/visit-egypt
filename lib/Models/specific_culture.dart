class SpecificCultureModel {
  String? message;
  List<Data>? data = [];
  int? status;

  SpecificCultureModel({this.message, this.data, this.status});

  SpecificCultureModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class Data {
  int? id;
  var categoryId;
  String? image;
  String? link;
  var rate;
  String? maincharacter;
  String? categoryName;
  String? title;
  String? description;

  Data(
      {this.id,
        this.image,
        this.link,
        this.rate,
        this.maincharacter,
        this.categoryId,
        this.categoryName,
        this.title,
        this.description,
      });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    categoryId = json['category_id'];
    link = json['link'];
    rate = json['rate'];
    maincharacter = json['maincharacter'];
    categoryName = json['category_name'];
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['image_path'] = this.image;
    data['link'] = this.link;
    data['rate'] = this.rate;
    data['maincharacter'] = this.maincharacter;

    data['category_name'] = this.categoryName;
    data['title'] = this.title;
    data['description'] = this.description;

    return data;
  }
}

class Category {
  int? id;
  String? image;
  String? type;
  String? createdAt;
  String? updatedAt;
  String? name;
  List<Translations>? translations = [];

  Category(
      {this.id,
        this.image,
        this.type,
        this.createdAt,
        this.updatedAt,
        this.name,
        this.translations});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    name = json['name'];
    if (json['translations'] != null) {
      json['translations'].forEach((v) {
        translations!.add(new Translations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['type'] = this.type;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['name'] = this.name;
    if (this.translations != null) {
      data['translations'] = this.translations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Translations {
  int? id;
  int? categoryId;
  String? name;
  String? locale;
  Null? createdAt;
  Null? updatedAt;

  Translations(
      {this.id,
        this.categoryId,
        this.name,
        this.locale,
        this.createdAt,
        this.updatedAt});

  Translations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    name = json['name'];
    locale = json['locale'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['name'] = this.name;
    data['locale'] = this.locale;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Translation {
  int? id;
  int? cultureId;
  String? title;
  String? description;
  String? locale;
  String? createdAt;
  String? updatedAt;

  Translation(
      {this.id,
        this.cultureId,
        this.title,
        this.description,
        this.locale,
        this.createdAt,
        this.updatedAt});

  Translation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cultureId = json['culture_id'];
    title = json['title'];
    description = json['description'];
    locale = json['locale'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['culture_id'] = this.cultureId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['locale'] = this.locale;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
