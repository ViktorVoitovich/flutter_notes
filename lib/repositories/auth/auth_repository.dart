import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:meta/meta.dart';

import '../../config/paths.dart';
import '../../entities/user_entity.dart';
import '../../models/models.dart';
import '../repositories.dart';

class AuthRepository extends BaseAuthRepository {
  final FirebaseFirestore _firestore;
  final firebase_auth.FirebaseAuth _firebaseAuth;

  AuthRepository({
    FirebaseFirestore firestore,
    firebase_auth.FirebaseAuth firebaseAuth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  @override
  void dispose() {}

  @override
  Future<User> loginAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    return await _firebaseUserToUser(authResult.user);
  }

  @override
  Future<User> signupWithEmailAndPassword({
    @required String email,
    @required String password,
  }) async {
    final currentUser = _firebaseAuth.currentUser;
    final authCredential = firebase_auth.EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    final authResult = await currentUser.linkWithCredential(authCredential);
    final user = await _firebaseUserToUser(authResult.user);

    _firestore
        .collection(Paths.users)
        .doc(user.id)
        .set(user.toEntity().toDocument());

    return user;
  }

  @override
  Future<User> loginWithEmailAndPassword({
    @required String email,
    @required String password,
  }) async {
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return await _firebaseUserToUser(authResult.user);
  }

  @override
  Future<User> logout() async {
    await _firebaseAuth.signOut();
    return await loginAnonymously();
  }

  @override
  Future<User> getCurrentUser() async {
    final currentUser = _firebaseAuth.currentUser;

    if (currentUser == null) {
      return null;
    }

    return await _firebaseUserToUser(currentUser);
  }

  @override
  bool isAnonymous() {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser.isAnonymous;
  }

  Future<User> _firebaseUserToUser(firebase_auth.User user) async {
    DocumentSnapshot userDoc =
        await _firestore.collection(Paths.users).doc(user.uid).get();

    if (userDoc.exists) {
      User user = User.fromEntity(UserEntity.fromSnapshot(userDoc));
      return user;
    }

    return User(
      id: user.uid,
      email: '',
    );
  }
}
