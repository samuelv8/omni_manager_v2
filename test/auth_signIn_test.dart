
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:omni_manager/api/auth.dart';

final String invalidEmail = "InvalidEmail";
final String validEmail = "validEmail";
final String validPassword = '123';
final String invalidPassword = '456';

class MockUserCredential extends Mock implements UserCredential{}
MockUserCredential userCredential = MockUserCredential();
class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override 
  Future<UserCredential> signInWithEmailAndPassword({required String email, required String password}) async {
    if (email == validEmail && password == validPassword)
    {
      return userCredential;
    }
    else
    {
      throw FirebaseAuthException(code: "Invalid signin.");
    }
  }
}



void main() {
  MockFirebaseAuth _firebaseAuthInstance = MockFirebaseAuth();
  test("Valid email and password", () async {
    expect(await signIn(validEmail, validPassword, _firebaseAuthInstance), userCredential);
  });

  test("Valid email and invalid password", () async {
    bool exceptionHappened = false;

    try
    {
      await signIn(validEmail, invalidPassword, _firebaseAuthInstance);
    }on FirebaseAuthException catch(e)
    {
      exceptionHappened = true;
    }
    expect(exceptionHappened, true);
  });

  test("Invalid email and valid password", () async {
    bool exceptionHappened = false;

    try
    {
      await signIn(invalidEmail, validPassword, _firebaseAuthInstance);
    }on FirebaseAuthException catch(e)
    {
      exceptionHappened = true;
    }
    expect(exceptionHappened, true);
  });
}