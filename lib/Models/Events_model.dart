class EventModel{
  String? message;
  List<Data>? data = [];
  int? status;

  EventModel({this.message, this.data, this.status});
  EventModel.fromJson(Map<String,dynamic>json){
    message = json['message'];
    if(json['data'] != null){
      json['data'].forEach((v){
        data!.add(new Data.fromJson(v));
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

class Data {
  int? id;
  int? user_id;
  String? title;
  String? description;
  DateTime? startDate;
  DateTime? endDate;
  String? phone;
  String? websiteLink;
  String? email;
  int? payment;
  String? catergory;
  String? image;
  String? location;
  int? price;


  Data(
      this.id,
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
      this.price);

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user_id = json['user_id'];
    title = json['title'];
    description = json['description'];
    startDate = DateTime.tryParse(json['startDate']);
    endDate = DateTime.tryParse(json['endDate']);
    phone = json['phone'];
    websiteLink = json['website'];
    email = json['email'];

    payment = json['type'];
    catergory = json['category_name'];
    image = json['image_path'];
    location = json['location'];
    price = json['Price'];


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.user_id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['phone'] = this.phone;
    data['websiteLink'] = this.websiteLink;
    data['email'] = this.email;
    data['payment'] = this.payment;
    data['catergory'] = this.catergory;
    data['image'] = this.image;
    data['location'] = this.location;
    data['Price'] = this.price;


    return data;
  }
}
