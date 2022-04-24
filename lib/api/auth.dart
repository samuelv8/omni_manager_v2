import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:omni_manager/utils/shared_prefs.dart';

CollectionReference users = FirebaseFirestore.instance.collection("Users");
bool loggedUserIsManager = false;

Future<UserCredential> signIn(String email, String password) async {
  try {
    return FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  } catch (e) {
    return Future.error(e);
  }
}

Future<void> sendEmailVerification(String userEmail) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user!= null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  } on FirebaseAuthException catch (e) {
    throw e;
  }
}

Future<bool> register(Map<String, dynamic> userData) async {
  try {
    var email = userData["email"];
    bool notRegistered = true;
    users
        .where("email", isEqualTo: email)
        .get()
        .then((snapshot) {if (snapshot.docs.isNotEmpty) notRegistered = false;
    });
    if (notRegistered){
      var uid = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: userData["email"], password: userData['password'])
          .then((credential) {
            
        return credential.user?.uid;

      });
      userData.remove("password");
      users
          .doc(uid)
          .set(userData, SetOptions(merge: true))
          .then((value) => print("User added"));
      return true;
    }
    else{
      print("Attempt to register with an already registered e-mail.");
      return false;
    }
  } catch (e) {
    throw Future.error(e);
  }
}

String getUserUid() {
  var user = FirebaseAuth.instance.currentUser;
  return user?.uid ?? Constants.prefs!.getString("uid")!;
}

Future<bool> updateInfo(String password) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) await user.updatePassword(password);
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> isUserManager(userUid) async {
  final snapshot = await users.doc(userUid).get();
  if (snapshot.exists) {
    Map data = snapshot.data() as Map;
    return data["manager"] ?? false;
  }
  return false;
}

// use somente quando sabe que o usuário está logado
Future<bool> updateUserData(Map<String, dynamic> userData) async {
  CollectionReference users = FirebaseFirestore.instance.collection("Users");
  String? managerEmail = userData.remove("manager_email");

  try {
    User? user = FirebaseAuth.instance.currentUser;
    users
        .doc(user?.uid)
        .set(userData, SetOptions(merge: true))
        .then((value) => print("User updated"));

    if (!userData["manager"]) {
      users.where('email', isEqualTo: managerEmail).limit(1).get()
          // this will return a QuerySnapshot
          .then((snapshot) {
        // get manager id from snapshot
        // no need to check for existence because it's checked before
        // the call to the register function
        final String managerDocID = snapshot.docs[0].id;
        users
            .doc(managerDocID)
            .collection("Employees")
            .doc(user?.uid)
            .set({"ref": users.doc(user?.uid)}, SetOptions(merge: true)).then(
                (value) => print("User reference added"));
      });
      CollectionReference metrics =
          FirebaseFirestore.instance.collection("Metrics");
      metrics.doc(user?.uid).set({"email": user?.email});
    }

    return true;
  } catch (e) {
    print(e.toString());
    return false;
  }
}
