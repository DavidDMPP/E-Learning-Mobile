import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart' as app_user;
import 'package:logging/logging.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger('AuthService');

  // Get current user
  app_user.User? get currentUser {
    final user = _auth.currentUser;
    if (user != null) {
      return app_user.User(
        uid: user.uid,
        name: user.displayName ?? '',
        npm: '',
        role: '',
        email: user.email ?? '',
      );
    }
    return null;
  }

  Future<app_user.User?> signIn(String npm, String password) async {
    try {
      _logger.info('Attempting to sign in user with NPM: $npm');

      QuerySnapshot userQuery = await _firestore
          .collection('users')
          .where('npm', isEqualTo: npm)
          .limit(1)
          .get();

      _logger.info('Firestore query completed');

      if (userQuery.docs.isEmpty) {
        _logger.warning('No user found for NPM: $npm');
        throw Exception('No user found for that NPM.');
      }

      DocumentSnapshot userDoc = userQuery.docs.first;
      String email = userDoc.get('email');

      if (email.isEmpty) {
        _logger.warning('Email not found for user with NPM: $npm');
        throw Exception('User email not found. Please contact support.');
      }

      _logger.info('Attempting Firebase Authentication');
      UserCredential authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      User? firebaseUser = authResult.user;

      if (firebaseUser == null) {
        _logger.warning('Firebase Auth successful but user is null');
        throw Exception('Authentication failed: User is null');
      }

      _logger.info('User successfully authenticated: ${firebaseUser.uid}');
      return app_user.User.fromMap(
          {...userDoc.data() as Map<String, dynamic>, 'uid': userDoc.id});
    } on FirebaseAuthException catch (e) {
      _logger.severe('Firebase Auth Error: ${e.code} - ${e.message}');
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided for that user.');
      } else {
        throw Exception('Authentication failed: ${e.message}');
      }
    } on FirebaseException catch (e) {
      _logger.severe('Firestore Error: ${e.code} - ${e.message}');
      throw Exception('Failed to retrieve user data: ${e.message}');
    } catch (e) {
      _logger.severe('Unexpected error during sign in: $e');
      throw Exception('An unexpected error occurred. Please try again later.');
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _logger.info('User signed out successfully');
    } catch (e) {
      _logger.severe('Error during sign out: $e');
      throw Exception('Failed to sign out. Please try again.');
    }
  }

  Future<app_user.User?> register(
      String npm, String email, String password, String name) async {
    try {
      _logger.info('Attempting to register new user with NPM: $npm');

      QuerySnapshot existingUser = await _firestore
          .collection('users')
          .where('npm', isEqualTo: npm)
          .limit(1)
          .get();

      if (existingUser.docs.isNotEmpty) {
        _logger.warning('NPM already in use: $npm');
        throw Exception('A user with this NPM already exists.');
      }

      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'name': name,
          'npm': npm,
          'email': email,
          'role': 'student',
        });

        _logger.info('New user registered successfully: ${user.uid}');
        return app_user.User(
          uid: user.uid,
          name: name,
          npm: npm,
          role: 'student',
          email: email,
        );
      } else {
        _logger.severe('Failed to create user');
        throw Exception('Failed to create user.');
      }
    } on FirebaseAuthException catch (e) {
      _logger.severe(
          'Firebase Auth Error during registration: ${e.code} - ${e.message}');
      throw Exception('Registration failed: ${e.message}');
    } on FirebaseException catch (e) {
      _logger.severe(
          'Firestore Error during registration: ${e.code} - ${e.message}');
      throw Exception('Failed to save user data: ${e.message}');
    } catch (e) {
      _logger.severe('Unexpected error during registration: $e');
      throw Exception(
          'An unexpected error occurred during registration. Please try again later.');
    }
  }
}
