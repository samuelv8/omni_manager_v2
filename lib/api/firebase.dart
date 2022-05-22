import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
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

  static Future<bool> notRegistered(String email) async {
    // flow: vai encontrar o doc com email, determinar se existe e retornar um bool
    return _users
        .where("email", isEqualTo: email)
        .limit(1)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isEmpty) {
        return false;
      }
      return true;
    });
  }

  static Future<bool> checkEmailValidated() async {
    // flow: vai verificar se email já foi verificado, caso contrário envia email de verificaçao novamente
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
    if (user != null)
      return user.emailVerified;
    else {
      print("Current user not found.");
      return false;
    }
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


  ///Gets filled forms with path [empID], where 'is_manager' is equal to 
  ///[isManager], and where release time is between [init] and [end]. 
  ///Parameters [init] and [end] are optional, if they are not provided,
  ///the default value will be respectively DateTime.fromMillisecondsSinceEpoch(0) 
  ///and DateTime.now()
  static Future<QuerySnapshot> getEmployeeFormsFromInitToEnd(
      String empID, bool isManager, [DateTime? init, DateTime? end]) {
    init = init ?? DateTime.fromMillisecondsSinceEpoch(0);
    end  = end  ?? DateTime.now();
    return _metrics
        .doc(empID)
        .collection("Formularies")
        .where('is_filled', isEqualTo: true)
        .where('is_manager', isEqualTo: isManager)
        .where('release_date',
            isGreaterThanOrEqualTo: Timestamp.fromDate(init),
            isLessThanOrEqualTo: Timestamp.fromDate(end)
            )
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
            final data = user.get('email');
            await Future.wait([sendEmail(data)]);
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

Future sendEmail(String userEmail) async {
  var body = '''

    Olá!

    Você recebeu seu formulário semanal na plataforma OmniManager.

    Não vai esquecer de preencher, ein?

    Att.,

    Equipe OmniManager

    ''';
  var subject = "Atenção! Formulário novo de acompanhamento OmniManager.";

  final uri = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

  final response = await http.post(uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'service_id': 'service_enf8b7n',
        'template_id': 'template_jty8x3m',
        'user_id': 'hSJYx0YlCi_pRKRlb',
        'template_params': {
          'user_message': body,
          'user_email': userEmail,
          'user_subject': subject
        }
      }));
  return response;
}
