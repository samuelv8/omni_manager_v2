import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omni_manager/api/auth.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _users = _firestore.collection('Users');
final CollectionReference _metrics = _firestore.collection('Metrics');

class Database {
  static String? userUid = getUserUid();

  static Future<bool> validateManager(Map<String, String> managerData) async {
    // flow: vai encontrar o doc com email, determinar se existe e retornar um bool
    return _users
        .where("email", isEqualTo: managerData["email"])
        .where("company", isEqualTo: managerData["company"])
        .where("department", isEqualTo: managerData["department"])
        .limit(1)
        .get()
        .then((snapshot) => snapshot.docs.isNotEmpty);
  }

  static Future<QuerySnapshot> listRatings() {
    return _metrics.doc(userUid).collection('Formularies').get();
  }

  static Future<QuerySnapshot> listEmployees() {
    return _users.doc(userUid).collection('Employees').get();
  }

  static Future<Map> listEmployeesWithName() {
    return listEmployees().then((snapshot) async {
      var employees = {};
      for (var doc in snapshot.docs) {
        final snap = await doc.get(FieldPath(['ref'])).get();
        employees.addAll({snap.id: snap.data()["name"]});
      }
      return employees;
    }).catchError((err) {
      print("Fail: $err");
      return {};
    });
  }

  static Future<DocumentSnapshot> getEmployeeData(DocumentSnapshot employee) {
    return employee.get(FieldPath(['ref'])).get();
  }

  static Future<DocumentReference> addForm(
      String? employee, bool isManager) async {
    return _metrics.doc(employee).collection('Formularies').add({
      'release_date': Timestamp.fromDate(DateTime.now()),
      'is_filled': false,
      'is_manager': isManager,
    });
  }

  static Future<QuerySnapshot> getUnfilledForm(
      {required bool isManager, String? employee}) {
    var docId = isManager ? employee : userUid;
    return _metrics
        .doc(docId)
        .collection('Formularies')
        .where('is_manager', isEqualTo: isManager)
        .where('is_filled', isEqualTo: false)
        .where('release_date',
            isGreaterThanOrEqualTo: Timestamp.fromDate(
                DateTime.now().subtract(const Duration(days: 7))))
        .limit(1)
        .get();
  }

  static Future<QuerySnapshot> getAllEmployeeForms(String empID) {
    return _metrics
        .doc(empID)
        .collection("Formularies")
        .where('is_filled', isEqualTo: true)
        .get();
  }

  static Future<QuerySnapshot> getEmployeeForms(String empID, bool isManager) {
    return _metrics
        .doc(empID)
        .collection("Formularies")
        .where('is_filled', isEqualTo: true)
        .where('is_manager', isEqualTo: isManager)
        .get();
  }

  static Future<QuerySnapshot> getEmployeeFormsLast7Days(
      String empID, bool isManager) {
    return _metrics
        .doc(empID)
        .collection("Formularies")
        .where('is_filled', isEqualTo: true)
        .where('is_manager', isEqualTo: isManager)
        .where('release_date',
            isGreaterThanOrEqualTo: Timestamp.fromDate(
                DateTime.now().subtract(const Duration(days: 7))))
        .get();
  }

  static Future<void> releaseForms() {
    final CollectionReference employees =
        _users.doc(userUid).collection('Employees');
    return employees.get().then((QuerySnapshot emp) => {
          emp.docs.forEach((element) async {
            final DocumentSnapshot user =
                await element.get(FieldPath(['ref'])).get();
            await Future.wait(
                [addForm(user.id, false), addForm(user.id, true)]);
          })
        });
  }

  static Future<void> fillForms(
      {required bool isManager,
      String? employee,
      int load: 0,
      int completion: 0,
      double quality: 0,
      double proactivity: 0}) {
    var docId = isManager ? employee : userUid;
    return _metrics
        .doc(docId)
        .collection('Formularies')
        .where('is_manager', isEqualTo: isManager)
        .where('is_filled', isEqualTo: false)
        .limit(1)
        .get()
        .then((snapshot) => snapshot.docs[0].reference.update({
              'work_load': load,
              'work_completion': completion,
              'work_quality': quality,
              'work_proactivity': proactivity,
              'is_filled': true,
              'submission_date': Timestamp.now()
            }));
  }

  static Future<QuerySnapshot> getUserFromEmail(String userEmail) {
    return _users.where("email", isEqualTo: userEmail).get();
  }

  static Future<bool> emailExistsInDatabase(String userEmail) {
    return getUserFromEmail(userEmail).then((value) => value.docs.isNotEmpty);
  }
}
