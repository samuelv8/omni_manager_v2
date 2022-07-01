import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:flutter_test/flutter_test.dart';

final instance = MockFirestoreInstance();

Future<bool> isUserManager(userUid) async {
  final snapshot = await instance.collection('users').doc(userUid).get();
  if (snapshot.exists) {
    Map data = snapshot.data() as Map;
    return data["manager"] ?? false;
  }
  return false;
}

void main() {
  bool isMan = false;
  test('Check if user is manager when actually is a Manager', () async {
    await instance.collection('users').add({
      'username': 'Bob',
      'manager': true,
    });
    await instance.collection('users').add({
      'username': 'Mega',
      'manager': false,
    });
    final snapshot = await instance.collection('users').get();
    final userId = snapshot.docs.first.id;
    isMan = await isUserManager(userId);
    expect(isMan, true);
  });
}
