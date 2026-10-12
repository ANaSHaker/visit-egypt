class AllCompaniesModel {
  String? message;
  List<Data>? data = [];
  int? status;

  AllCompaniesModel({this.message, this.data, this.status});

  AllCompaniesModel.fromJson(Map<String, dynamic> json) {
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
  int? rate;
  String? type;
  String? websiteLink;
  String? contactLink;
  String? createdAt;
  String? updatedAt;
  String? name;
  String? description;
  List<Translations>? translations = [];

  Data(
      {this.id,
        this.image,
        this.rate,
        this.type,
        this.websiteLink,
        this.contactLink,
        this.createdAt,
        this.updatedAt,
        this.name,
        this.description,
        this.translations});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    rate = json['rate'];
    type = json['type'];
    websiteLink = json['website_link'];
    contactLink = json['contact_link'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
    data['type'] = this.type;
    data['website_link'] = this.websiteLink;
    data['contact_link'] = this.contactLink;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
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
  int? companyId;
  String? name;
  String? description;
  String? locale;

  Translations(
      {this.id, this.companyId, this.name, this.description, this.locale});

  Translations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    name = json['name'];
    description = json['description'];
    locale = json['locale'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_id'] = this.companyId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['locale'] = this.locale;
    return data;
  }
}