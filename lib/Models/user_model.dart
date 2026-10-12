class userData {

  // output data when login
  late String message;
  Data? data;

  userData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }
}
// data of user
class Data {
  String? firebase_id;
  String? name;
  String? email;



  Data.fromJson(Map<String, dynamic> json) {
    firebase_id = json['firebase_id'];
    name = json['name'];
    email = json['email'];

  }
}
