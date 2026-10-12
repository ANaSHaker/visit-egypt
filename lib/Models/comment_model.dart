class CommentData {

  // output data when login
  bool? status;
  late String message;
  Data? data;

  CommentData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }
}
// data of user
class Data {
  String? user_id;
  String? company_id;
  String? body;



  Data.fromJson(Map<String, dynamic> json) {
    user_id = json['user_id'];
    company_id = json['company_id'];
    body = json['body'];

  }
}
