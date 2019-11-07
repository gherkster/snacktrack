import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class BaseAuth {
  Future<FirebaseUser> emailSignIn(String email, String password);

  Future<void> emailSignOut();

  Future<String> emailSignUp(String email, String password);

  Future<void> sendEmailVerification();

  Future<bool> isEmailVerified();


  Future<FirebaseUser> signInWithGoogle();
  Future<GoogleIdentity> getGoogleIdentity();
  Future<void> signOutWithGoogle();


  Future<FirebaseUser> getCurrentUser();
  Future<String> getCurrentUserUid();
}

class Auth implements BaseAuth {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<FirebaseUser> emailSignIn(String email, String password) async {
    AuthResult result = await auth.signInWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = result.user;

    assert(user != null);
    assert(await user.getIdToken() != null);

    return user;
  }

  Future<void> emailSignOut() async {
    return auth.signOut();
  }

  Future<String> emailSignUp(String email, String password) async {
    AuthResult result = await auth.createUserWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await auth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await auth.currentUser();
    return user.isEmailVerified;
  }

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    final AuthCredential cred = GoogleAuthProvider.getCredential(idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);
    final AuthResult result = await auth.signInWithCredential(cred);
    FirebaseUser user = result.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await auth.currentUser();
    assert(user.uid == currentUser.uid);

    return user;
  }

  Future<GoogleIdentity> getGoogleIdentity() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    return googleSignIn.currentUser;
  }

  Future<void> signOutWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await auth.currentUser();
    return user;
  }

  Future<String> getCurrentUserUid() async {
    FirebaseUser user = await auth.currentUser();
    return user.uid;
  }
}
