class AllCategoriesCity {
  String? message;
  List<Data>? data=[];
  int? status;

  AllCategoriesCity({this.message, this.data, this.status});

  AllCategoriesCity.fromJson(Map<String, dynamic> json) {
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
  String? image;
  String? type;
  String? createdAt;
  String? updatedAt;
  List<Places>? places=[];
  String? name;
  Pivot? pivot;
  List<Translations>? translations=[];

  Data(
      {this.id,
        this.image,
        this.type,
        this.createdAt,
        this.updatedAt,
        this.places,
        this.name,
        this.pivot,
        this.translations});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['places'] != null) {
      json['places'].forEach((v) {
        places!.add(new Places.fromJson(v));
      });
    }
    name = json['name'];
    pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
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
    if (this.places != null) {
      data['places'] = this.places!.map((v) => v.toJson()).toList();
    }
    data['name'] = this.name;
    if (this.pivot != null) {
      data['pivot'] = this.pivot!.toJson();
    }
    if (this.translations != null) {
      data['translations'] = this.translations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Places {
  int? id;
  String? image;
  var rate;
  String? location;
  String? phone;
  String? website;
  int? status;
  int? cityId;
  int? categoryId;
  int? userId;
  String? createdAt;
  String? updatedAt;
  String? imagePath;
  String? name;
  String? description;
  List<Translations>? translations=[];

  Places(
      {this.id,
        this.image,
        this.rate,
        this.location,
        this.phone,
        this.website,
        this.status,
        this.cityId,
        this.categoryId,
        this.userId,
        this.createdAt,
        this.updatedAt,
        this.imagePath,
        this.name,
        this.description,
        this.translations});

  Places.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    rate = json['rate'];
    location = json['location'];
    phone = json['phone'];
    website = json['website'];
    status = json['status'];
    cityId = json['city_id'];
    categoryId = json['category_id'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    imagePath = json['image_path'];
    name = json['name'];
    description = json['description'];
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
    data['rate'] = this.rate;
    data['location'] = this.location;
    data['phone'] = this.phone;
    data['website'] = this.website;
    data['status'] = this.status;
    data['city_id'] = this.cityId;
    data['category_id'] = this.categoryId;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['image_path'] = this.imagePath;
    data['name'] = this.name;
    data['description'] = this.description;
    if (this.translations != null) {
      data['translations'] = this.translations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Translations {
  int? id;
  int? placeId;
  String? name;
  String? description;
  String? locale;
  String? createdAt;
  String? updatedAt;

  Translations(
      {this.id,
        this.placeId,
        this.name,
        this.description,
        this.locale,
        this.createdAt,
        this.updatedAt});

  Translations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    placeId = json['place_id'];
    name = json['name'];
    description = json['description'];
    locale = json['locale'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['locale'] = this.locale;
    data['created_at'] = this.createdAt;
    data['description'] = this.description;
    data['place_id'] = this.placeId;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Pivot {
  int? cityId;
  int? categoryId;

  Pivot({this.cityId, this.categoryId});

  Pivot.fromJson(Map<String, dynamic> json) {
    cityId = json['city_id'];
    categoryId = json['category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city_id'] = this.cityId;
    data['category_id'] = this.categoryId;
    return data;
  }
}

class Translations2 {
  int? id;
  int? categoryId;
  String? name;
  String? locale;
  String? createdAt;
  String? updatedAt;

  Translations2(
      {this.id,
        this.categoryId,
        this.name,
        this.locale,
        this.createdAt,
        this.updatedAt});

  Translations2.fromJson(Map<String, dynamic> json) {
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
    data['name'] = this.name;
    data['category_id'] = this.categoryId;
    data['locale'] = this.locale;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
