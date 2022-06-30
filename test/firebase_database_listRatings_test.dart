import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final instance = MockFirestoreInstance();

Future<QuerySnapshot> listRatings(userId) {
  return instance
      .collection('users')
      .doc(userId)
      .collection('Formularies')
      .get();
}

void main() {
  test('Check if listRatings is listing the ratings', () async {
    await instance
        .collection('users')
        .add({'username': 'Bob', 'manager': true});
    await instance.collection('users').add({
      'username': 'Mega',
      'manager': false,
    });
    final obj = {
      'R1': 5,
      'R2': 4,
      'R3': 3,
      'R4': 4,
    };
    final snapshot = await instance.collection('users').get();
    final userId = snapshot.docs.first.id;
    await instance
        .collection('users')
        .doc(userId)
        .collection('Formularies')
        .add({
      'R1': 5,
      'R2': 4,
      'R3': 3,
      'R4': 4,
    });
    final ratings = await listRatings(userId);
    expect(ratings.docs.first.data(), obj);
  });
}
