
import '../Utils/chatUtils.dart';

class MessageField {
  static final String createdAt = 'createdAt';
}

class Message {

  final String idUser;
  final String? Admin;
  final String? urlAvatar;
  final String? username;
  final String message;
  final DateTime? createdAt;
  final String? type;
  final String? fromType;

  const Message({
    required this.idUser,
    this.Admin,
    this.fromType,
    required this.urlAvatar,
    required this.username,
    required this.message,
    required this.createdAt,
    required this.type,
  });

  static Message fromJson(Map<String, dynamic> json) => Message(
    idUser: json['idUser'],
    fromType: json['fromType'],
    Admin: json['Admen'],
    urlAvatar: json['urlAvatar'],
    username: json['username'],
    message: json['message'],
    type: json['type'],
    createdAt: Utils.toDateTime(json['createdAt']),
  );

  Map<String, dynamic> toJson() => {
    'idUser': idUser,
    'Admin': Admin,
    'fromType': fromType,
    'urlAvatar': urlAvatar,
    'username': username,
    'message': message,
    'type': type,
    'createdAt': Utils.fromDateTimeToJson(createdAt!),
  };
}
