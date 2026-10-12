import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:visit_egypt/Models/message_model.dart';

import '../../Utils/chatUtils.dart';

class FirebaseApi {
  // static Stream<List<User>> getUsers() => FirebaseFirestore.instance
  //     .collection('users')
  //     .orderBy(UserField.lastMessageTime, descending: true)
  //     .snapshots()
  //     .transform(Utils.transformer(User.fromJson));

  static Future uploadMessage(String idUser, String message) async {
    final refMessages =
    FirebaseFirestore.instance.collection('chats/$idUser/messages');

    final newMessage = Message(
      idUser: FirebaseAuth.instance.currentUser!.uid,
      urlAvatar: FirebaseAuth.instance.currentUser!.photoURL,
      username: FirebaseAuth.instance.currentUser!.displayName,
      message: message,
      createdAt: DateTime.now(),
      type: message.contains("https://firebasestorage.googleapis.com")?'img':'txt',
    );
    await refMessages.add(newMessage.toJson());
    //
    // final refUsers = FirebaseFirestore.instance.collection('users');
    // await refUsers
    //     .doc(idUser)
    //     .update({UserField.lastMessageTime: DateTime.now()});
  }

  static Future uploadMessageAdmin(String idUser, String message) async {
    final refMessages =
     FirebaseFirestore.instance.collection('Admin').doc('${FirebaseAuth.instance.currentUser!.uid}').collection('messages').doc();

    final newMessage = Message(
      Admin:"KhuqJE6fnDVuH1gYhAwFvdr0wbD3",
      fromType:"User",
      idUser: FirebaseAuth.instance.currentUser!.uid,
      urlAvatar: FirebaseAuth.instance.currentUser!.photoURL,
      username: FirebaseAuth.instance.currentUser!.displayName,
      message: message,
      createdAt: DateTime.now(),
      type: message.contains("https://firebasestorage.googleapis.com")?'img':'txt',
    );
    await refMessages.set(newMessage.toJson()).whenComplete(() {
       FirebaseFirestore.instance.collection('Admin').doc('${FirebaseAuth.instance.currentUser!.uid}').set(
          {
            "idUser": FirebaseAuth.instance.currentUser!.uid,
            "photoUrl": FirebaseAuth.instance.currentUser!.photoURL,
            "Name": FirebaseAuth.instance.currentUser!.displayName,
          }
      );
    });
    //
    // final refUsers = FirebaseFirestore.instance.collection('users');
    // await refUsers
    //     .doc(idUser)
    //     .update({UserField.lastMessageTime: DateTime.now()});
  }
  static Stream<List<Message>> getMessages(String idUser) =>
      FirebaseFirestore.instance
          .collection('chats/$idUser/messages')
          .orderBy(MessageField.createdAt, descending: true)
          .snapshots()
          .transform(Utils.transformer(Message.fromJson));

  static Stream<List<Message>> getMessagesAdmin(String idUser) =>
      FirebaseFirestore.instance
          .collection('Admin/${FirebaseAuth.instance.currentUser!.uid}/messages')
          .orderBy(MessageField.createdAt, descending: true)
          .snapshots()
          .transform(Utils.transformer(Message.fromJson));

  static Future addRandomUsers(List<User> users) async {
    final refUsers = FirebaseFirestore.instance.collection('users');

    final allUsers = await refUsers.get();
    if (allUsers.size != 0) {
      return;
    } else {
      for (final user in users) {
        final userDoc = refUsers.doc();
        // final newUser = user.copyWith(idUser: userDoc.id);

        // await userDoc.set(newUser.toJson());
      }
    }
  }
}
