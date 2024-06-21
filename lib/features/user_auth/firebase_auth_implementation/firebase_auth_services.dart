import 'package:firebase_auth/firebase_auth.dart';
import 'package:sotenooficial/global/common/toast.dart';

class FirebaseAuthService{
  FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Future<User?>
  signUpWithEmailAndPassword ( String email, String password) async {
    try{
      UserCredential credential =
     await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch(e) {
        if(e.code == 'email-already-in-use'){
          showToast(message: 'O Endereço de email já está a ser usado');
        }
        else {
          showToast(message: 'Ocorreu um erro:${e.code}');
        }
    }
    return null;
  }

  Future<User?>
  signInWithEmailAndPassword ( String email, String password) async {
    try{
      UserCredential credential =
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException  catch(e) {

      if(e.code == 'user-not-found' || e.code == 'wrong-password'){
        showToast(message: 'Email ou Senha Inválido');
      } else{
        showToast(message: 'Ocorreu um erro: ${e.code}');
      }

    }
    return null;
  }

}