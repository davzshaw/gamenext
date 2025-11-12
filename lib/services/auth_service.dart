import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserModel?> signIn(String email, String password) async {
    try {
      print('🔐 Attempting sign in for: $email');
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('✅ Sign in successful, getting user data...');
      final userData = await getUserData(credential.user!.uid);
      print('✅ User data retrieved: ${userData?.displayName}');
      return userData;
    } catch (e) {
      print('❌ Sign in error: $e');
      throw Exception('Error al iniciar sesión: $e');
    }
  }

  Future<UserModel?> signUp(String email, String password, String displayName) async {
    try {
      print('📝 Attempting sign up for: $email');
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('✅ User created in Auth, creating Firestore document...');
      
      final user = UserModel(
        uid: credential.user!.uid,
        displayName: displayName,
        email: email,
      );

      await _firestore.collection('users').doc(user.uid).set(user.toJson());
      print('✅ User document created in Firestore');
      return user;
    } catch (e) {
      print('❌ Sign up error: $e');
      throw Exception('Error al registrarse: $e');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Error al enviar correo: $e');
    }
  }

  Future<UserModel?> getUserData(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromJson(doc.data()!);
    }
    return null;
  }

  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(uid).update(data);
  }
}
