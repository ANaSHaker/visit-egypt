import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:visit_egypt/Services/Authentication/authentificationService.dart';

class UserDatabaseHelper {
  static const String USERS_COLLECTION_NAME = "users";
  static const String Email_KEY = 'email';
  static const String Password_KEY = 'password';
  static const String Name_KEY = 'name';
  static const String PHONE_KEY = 'phone';
  static const String DP_KEY = "display_picture";

  UserDatabaseHelper._privateConstructor();
  static UserDatabaseHelper _instance =
      UserDatabaseHelper._privateConstructor();
  factory UserDatabaseHelper() {
    return _instance;
  }
  FirebaseFirestore? _firebaseFirestore;
  FirebaseFirestore get firestore {
    if (_firebaseFirestore == null) {
      _firebaseFirestore = FirebaseFirestore.instance;
    }
    return _firebaseFirestore!;
  }
  Future<List<DocumentSnapshot>> getallUsers() async
  {
    List<DocumentSnapshot> documentSnapshot;
    QuerySnapshot querytSnapshot = await firestore.collection(USERS_COLLECTION_NAME).get();
    documentSnapshot = querytSnapshot.docs;
    return documentSnapshot;
  }
  Future<void> createNewUser(String uid) async {
    await firestore.collection(USERS_COLLECTION_NAME).doc(uid).set({
      DP_KEY: null,
      PHONE_KEY: null,
      Name_KEY : null,
      Email_KEY:null,
      Password_KEY:null,
    });
  }

  Future<void> deleteCurrentUserData() async {
    final uid = AuthentificationService().currentUser.uid;
    final docRef = firestore.collection(USERS_COLLECTION_NAME).doc(uid);
    await docRef.delete();
  }


  Stream<DocumentSnapshot> get currentUserDataStream {
    String uid = AuthentificationService().currentUser.uid;
    return firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .get()
        .asStream();
  }

  Future<bool> updatePhoneForCurrentUser(String phone) async {
    String uid = AuthentificationService().currentUser.uid;
    final userDocSnapshot =
        firestore.collection(USERS_COLLECTION_NAME).doc(uid);
    await userDocSnapshot.update({PHONE_KEY: phone});
    return true;
  }
  Future<bool> updateEmailForCurrentUser(String email) async {
    String uid = AuthentificationService().currentUser.uid;
    final userDocSnapshot =
    firestore.collection(USERS_COLLECTION_NAME).doc(uid);
    await userDocSnapshot.update({Email_KEY: email});
    return true;
  }
  Future<bool> updatePasswordForCurrentUser(String password) async {
    String uid = AuthentificationService().currentUser.uid;
    final userDocSnapshot =
    firestore.collection(USERS_COLLECTION_NAME).doc(uid);
    await userDocSnapshot.update({Password_KEY: password});
    return true;
  }
  Future<bool> updateNameForCurrentUser(String name) async {
    String uid = AuthentificationService().currentUser.uid;
    final userDocSnapshot =
    firestore.collection(USERS_COLLECTION_NAME).doc(uid);
    await userDocSnapshot.update({Name_KEY: name});
    return true;
  }

  String getPathForCurrentUserDisplayPicture() {
    final String currentUserUid = AuthentificationService().currentUser.uid;
    return "user/display_picture/$currentUserUid";
  }

  Future<bool> uploadDisplayPictureForCurrentUser(String url) async {
    String uid = AuthentificationService().currentUser.uid;
    final userDocSnapshot =
        firestore.collection(USERS_COLLECTION_NAME).doc(uid);
    await userDocSnapshot.update(
      {DP_KEY: url},
    );
    return true;
  }

  Future<bool> removeDisplayPictureForCurrentUser() async {
    String uid = AuthentificationService().currentUser.uid;
    final userDocSnapshot =
        firestore.collection(USERS_COLLECTION_NAME).doc(uid);
    await userDocSnapshot.update(
      {
        DP_KEY: FieldValue.delete(),
      },
    );
    return true;
  }

  Future<String> get displayPictureForCurrentUser async {
    String uid = AuthentificationService().currentUser.uid;
    final userDocSnapshot =
        await firestore.collection(USERS_COLLECTION_NAME).doc(uid).get();
    return userDocSnapshot.data()![DP_KEY];
  }
}
