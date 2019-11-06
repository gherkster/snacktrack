import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseUser user;

  Future<bool> isLoggedIn() async {
    this.user = await auth.currentUser();
    if (this.user == null) {
      return false;
    }
    else return true;
  }

  Future<FirebaseUser> handleSignInEmail(String email, String password) async {  // TODO Move to auth class
    AuthResult result = await auth.signInWithEmailAndPassword(email: email, password: password);
    this.user = result.user;

    assert(user != null);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await auth.currentUser();
    assert(user.uid == currentUser.uid);

    print('signin success $user');
    return user;
  }

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    final AuthCredential cred = GoogleAuthProvider.getCredential(idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);

    final AuthResult authResult = await auth.signInWithCredential(cred);
    user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await auth.currentUser();
    assert(user.uid == currentUser.uid);

    return 'google sign in succeeded: $user';
  }
  void signOutGoogle() async {
    await googleSignIn.signOut();
  }
}
