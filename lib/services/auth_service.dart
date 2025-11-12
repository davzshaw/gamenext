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
      
      try {
        final userData = await getUserData(credential.user!.uid);
        if (userData != null) {
          print('✅ User data retrieved: ${userData.displayName}');
          return userData;
        }
      } catch (e) {
        print('⚠️ Could not get Firestore data, using Auth data: $e');
      }
      
      // Fallback: crear usuario con datos de Auth si Firestore falla
      print('🔄 Creating fallback user from Auth data');
      return UserModel(
        uid: credential.user!.uid,
        displayName: credential.user!.displayName ?? email.split('@')[0],
        email: email,
        photoUrl: credential.user!.photoURL,
      );
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
      print('✅ User created in Auth');
      
      final user = UserModel(
        uid: credential.user!.uid,
        displayName: displayName,
        email: email,
      );

      try {
        print('📝 Creating Firestore document...');
        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(user.toJson())
            .timeout(const Duration(seconds: 5));
        print('✅ User document created in Firestore');
      } catch (e) {
        print('⚠️ Could not create Firestore document: $e');
        print('✅ Continuing with Auth-only user');
      }
      
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
    try {
      print('🔍 Getting user document from Firestore: users/$uid');
      
      final doc = await _firestore
          .collection('users')
          .doc(uid)
          .get()
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              print('⏱️ Timeout getting user document');
              throw Exception('Timeout getting user data');
            },
          );
      
      print('📄 Document exists: ${doc.exists}');
      
      if (doc.exists) {
        final data = doc.data();
        print('📦 Document data: $data');
        
        if (data == null) {
          print('⚠️ Document data is null');
          return null;
        }
        
        try {
          final user = UserModel.fromJson(data);
          print('✅ UserModel created successfully: ${user.displayName}');
          return user;
        } catch (e) {
          print('❌ Error parsing UserModel: $e');
          print('📦 Raw data was: $data');
          return null;
        }
      }
      
      print('⚠️ User document not found in Firestore');
      return null;
    } catch (e, stackTrace) {
      print('❌ Error getting user data: $e');
      print('📚 Stack trace: $stackTrace');
      return null;
    }
  }

  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(uid).update(data);
  }
}
