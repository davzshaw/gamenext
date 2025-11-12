import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _currentUser;
  bool _isLoading = true;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  AuthProvider() {
    _initAuth();
  }

  Future<void> _initAuth() async {
    print('🚀 Initializing AuthProvider...');
    
    // Timeout de seguridad: si después de 5 segundos no hay respuesta, forzar isLoading = false
    Future.delayed(const Duration(seconds: 5), () {
      if (_isLoading) {
        print('⏱️ Timeout: Forcing isLoading = false');
        _isLoading = false;
        notifyListeners();
      }
    });
    
    _authService.authStateChanges.listen((User? user) async {
      print('👤 Auth state changed: ${user?.email ?? "null"}');
      try {
        if (user != null) {
          print('📥 Fetching user data from Firestore for uid: ${user.uid}');
          final userData = await _authService.getUserData(user.uid).timeout(
            const Duration(seconds: 8),
            onTimeout: () {
              print('⏱️ Timeout fetching user data');
              return null;
            },
          );
          print('✅ User data loaded: ${userData?.displayName ?? "null"}');
          _currentUser = userData;
        } else {
          print('🚪 User logged out');
          _currentUser = null;
        }
      } catch (e) {
        print('❌ Error fetching user data: $e');
        _currentUser = null;
      } finally {
        _isLoading = false;
        print('🔄 Notifying listeners, isAuthenticated: $isAuthenticated, isLoading: $_isLoading');
        notifyListeners();
      }
    });
  }

  Future<bool> signIn(String email, String password) async {
    try {
      print('🔑 AuthProvider: Starting sign in...');
      _errorMessage = null;
      notifyListeners();

      final user = await _authService.signIn(email, password);
      if (user != null) {
        print('✅ AuthProvider: Sign in successful');
        _currentUser = user;
        notifyListeners();
        return true;
      }
      print('⚠️ AuthProvider: Sign in returned null user');
      return false;
    } catch (e) {
      print('❌ AuthProvider: Sign in failed - $e');
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(String email, String password, String displayName) async {
    try {
      print('📝 AuthProvider: Starting sign up...');
      _errorMessage = null;

      final user = await _authService.signUp(email, password, displayName);
      if (user != null) {
        print('✅ AuthProvider: Sign up successful, setting _currentUser');
        _currentUser = user;
        print('🔔 AuthProvider: Calling notifyListeners(), isAuthenticated: $isAuthenticated');
        notifyListeners();
        print('✅ AuthProvider: notifyListeners() called, returning true');
        return true;
      }
      print('⚠️ AuthProvider: Sign up returned null user');
      return false;
    } catch (e) {
      print('❌ AuthProvider: Sign up failed - $e');
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _currentUser = null;
    notifyListeners();
  }

  Future<bool> resetPassword(String email) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authService.resetPassword(email);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    if (_currentUser != null) {
      await _authService.updateUserProfile(_currentUser!.uid, data);
      _currentUser = await _authService.getUserData(_currentUser!.uid);
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
