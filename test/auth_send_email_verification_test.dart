
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:omni_manager/api/auth.dart';

bool globalEmailVeriifed = false;
bool globalErrorWhileSendingEmailVerification = false;
class MockUser extends Mock implements User{
  @override 
  bool get emailVerified => globalEmailVeriifed;

  @override 
  Future<void> sendEmailVerification([ActionCodeSettings? actionCodeSettings]) async {
    if(globalErrorWhileSendingEmailVerification)
    {
      throw FirebaseAuthException(code:"Error while sending email");
    }
  }
}
MockUser? globalUser;

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override 
  User? get currentUser => globalUser;
}

 

void main() {
  MockFirebaseAuth _firebaseAuthInstance = MockFirebaseAuth();
  group("Valid emails", (){
    setUp((){
      globalErrorWhileSendingEmailVerification = false;
    });
    test("Null user", () async {
      bool exceptionHappened = false;
      globalUser = null;
      try
      {
        await sendEmailVerification(_firebaseAuthInstance);
      }on FirebaseAuthException catch(e)
      {
        exceptionHappened = true;
      }
      expect(exceptionHappened, false);
    });


    test("Valid user with verified email", () async {
      bool exceptionHappened = false;
      globalUser = MockUser();
      globalEmailVeriifed = true;
      try
      {
        await sendEmailVerification(_firebaseAuthInstance);
      }on FirebaseAuthException 
      {
        exceptionHappened = true;
      }
      expect(exceptionHappened, false);
    });

    test("Valid user with unverified email", () async {
      bool exceptionHappened = false;
      globalUser = MockUser();
      globalEmailVeriifed = false;
      try
      {
        await sendEmailVerification(_firebaseAuthInstance);
      }on FirebaseAuthException 
      {
        exceptionHappened = true;
      }
      expect(exceptionHappened, false);
    });
  });

group("Invalid emails", (){
    setUp((){
      globalErrorWhileSendingEmailVerification = true;
    });
    test("Null user", () async {
      bool exceptionHappened = false;
      globalUser = null;
      try
      {
        await sendEmailVerification(_firebaseAuthInstance);
      }on FirebaseAuthException catch(e)
      {
        exceptionHappened = true;
      }
      expect(exceptionHappened, false);
    });


    test("Valid user with verified email", () async {
      bool exceptionHappened = false;
      globalUser = MockUser();
      globalEmailVeriifed = true;
      try
      {
        await sendEmailVerification(_firebaseAuthInstance);
      }on FirebaseAuthException 
      {
        exceptionHappened = true;
      }
      expect(exceptionHappened, false);
    });

    test("Valid user with unverified email", () async {
      bool exceptionHappened = false;
      globalUser = MockUser();
      globalEmailVeriifed = false;
      try
      {
        await sendEmailVerification(_firebaseAuthInstance);
      }on FirebaseAuthException catch(e)
      {
        exceptionHappened = true;
      }
      expect(exceptionHappened, true);
    });
  });
}