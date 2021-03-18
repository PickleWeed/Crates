import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'models/user.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

var _firebaseRef = FirebaseDatabase().reference().child('users');

Future<FirebaseUser> createUserWithEmailAndPassword(email, password) async {
  // REGISTER WITH EMAIL AND PASSWORD
  final FirebaseUser user = (await
  _auth.createUserWithEmailAndPassword(
    email: email,
    password: password,
  )).user;
  return user;
}

void createUserDetails(userDB, username, email){
  FirebaseUser user = userDB;
   _firebaseRef.child(user.uid).set({
     'userID':  user.uid, //Get from authentication db
     'username': username,
     'email': email,
     'isAdmin': true, //default false,
  });
}

Future<FirebaseUser> signInWithEmailAndPassword(email, password) async {
  final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
    email: email,
    password: password,
  )).user;
  return user;
}


Future<User> isAdminCheck(userDB) async{
  FirebaseUser user = userDB;
  DataSnapshot snapshot =  await _firebaseRef.child(user.uid).once();
  User _user = new User(userID: user.uid, username: snapshot.value['username'],
      email:snapshot.value['email'], isAdmin: snapshot.value['isAdmin']);
  return _user;
}

Future<FirebaseUser> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken);
  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);
  final FirebaseUser currentUser = await _auth.currentUser();
  assert(currentUser.uid == user.uid);

  return user;
}
