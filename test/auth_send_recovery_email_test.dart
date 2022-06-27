
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:omni_manager/api/auth.dart';

final String invalidEmail = "InvalidEmail";
final String validEmail = "validEmail";
class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override 
  Future<void> sendPasswordResetEmail({required String email, ActionCodeSettings? actionCodeSettings}) async {
    if(email == invalidEmail) 
    {
      throw FirebaseAuthException(code: "Invalid Email");
    } 
  }
}



void main() {
  MockFirebaseAuth _firebaseAuthInstance = MockFirebaseAuth();
  test("Send to a valid email", () async {
    //when(_firebaseAuthInstance.sendPasswordResetEmail(email: validEmail)).thenAnswer((_) async {;});
    bool exceptionHappened = false;

    try
    {
      await sendRecoveryEmail(validEmail, _firebaseAuthInstance);
    }on FirebaseAuthException catch(e)
    {
      exceptionHappened = true;
    }
    expect(exceptionHappened, false);
  });

  test("Send to an invalid email", () async {
    //when(_firebaseAuthInstance.sendPasswordResetEmail(email: validEmail)).thenAnswer((_) async {;});
    bool exceptionHappened = false;

    try
    {
      await sendRecoveryEmail(invalidEmail, _firebaseAuthInstance);
    }on FirebaseAuthException catch(e)
    {
      exceptionHappened = true;
    }
    expect(exceptionHappened, true);
  });
}