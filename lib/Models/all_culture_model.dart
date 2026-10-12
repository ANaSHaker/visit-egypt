class ClutureModel {
  String? message;
  List<CultureData>? data = [];
  double? status;

  ClutureModel({this.message, this.data, this.status});

  ClutureModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data!.add(new CultureData.fromJson(v));
      });
       json['status'];

    }
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

class CultureData {
  int? id;
  String? image;
  String? title;


  CultureData(
      {this.id,
        this.image,

        this.title,
       });

  CultureData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];

    title = json['name'];


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;

    data['name'] = this.title;


    return data;
  }
}
