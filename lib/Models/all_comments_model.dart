class AllCommentsModel {
  String? message;
  List<DataComment>? data=[];
  int? status;

  AllCommentsModel({this.message, this.data, this.status});

  AllCommentsModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data!.add(new DataComment.fromJson(v));
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

class DataComment {
  int? id;
  int? userId;
  String? commentableType;
  int? commentableId;
  String? body;
  String? createdAt;
  String? updatedAt;
  String? firebaseId;
  User? user;

  DataComment(
      {this.id,
        this.userId,
        this.commentableType,
        this.commentableId,
        this.body,
        this.createdAt,
        this.updatedAt,
        this.firebaseId,
        this.user});

  DataComment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    commentableType = json['commentable_type'];
    commentableId = json['commentable_id'];
    body = json['body'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    firebaseId = json['firebase_id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['commentable_type'] = this.commentableType;
    data['commentable_id'] = this.commentableId;
    data['body'] = this.body;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['firebase_id'] = this.firebaseId;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? firebaseId;
  String? name;
  String? email;
  String? phone;
  String? emailVerifiedAt;
  int? admin;
  String? createdAt;
  String? updatedAt;
  String? jwtToken;

  User(
      {this.id,
        this.firebaseId,
        this.name,
        this.email,
        this.phone,
        this.emailVerifiedAt,
        this.admin,
        this.createdAt,
        this.updatedAt,
        this.jwtToken});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firebaseId = json['firebase_id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    emailVerifiedAt = json['email_verified_at'];
    admin = json['admin'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    jwtToken = json['jwtToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firebase_id'] = this.firebaseId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['admin'] = this.admin;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['jwtToken'] = this.jwtToken;
    return data;
  }
}
