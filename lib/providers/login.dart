import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final String uid;
  final String email;

  const User({@required this.uid, @required this.email});
}

class SignIn with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User _currentUser;
  String _username;

  Future<String> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    DocumentSnapshot data =
        await Firestore.instance.collection('Users').document(email).get();

    if (!(data.exists)) {
      print(email);
      print('null');
      return null;
    } else if (data['isAdmin'] == false) {
      return null;
    } else {
      _username = data['username'];
    }

    final AuthResult auth = await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .catchError((e) {
      return null;
    });

    if (auth == null) {
      return null;
    }

    final FirebaseUser user = auth.user;
    print(user.email);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    _currentUser = User(uid: user.uid, email: user.email);
    _prefs.setString('email', _currentUser.email);
    _prefs.setString('id', _currentUser.uid);
    _prefs.setString('username', _username);
    notifyListeners();
    return 'Signed in admin ${_currentUser.email}';
  }

  void autoLogin() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var uid = _prefs.getString('id');
    var email = _prefs.getString('email');
    var username = _prefs.getString('username');
    if(uid != null) {
      _currentUser = User(uid: uid, email: email);
      _username = username;
    }
    notifyListeners();
  }

  void signOut() async {
    await _auth.signOut();
    _currentUser = null;
    _username = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    prefs.remove('id');
    prefs.remove('username');
    notifyListeners();
  }

  User get curUser {
    return _currentUser;
  }

  String get username {
    return _username;
  }
}
