import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import '../models/material.dart';
import '../models/quiz.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // User methods
  Future<void> createUser(User user) async {
    await _db.collection('users').doc(user.uid).set(user.toMap());
  }

  Future<User> getUser(String uid) async {
    DocumentSnapshot doc = await _db.collection('users').doc(uid).get();
    return User.fromMap({...doc.data() as Map<String, dynamic>, 'uid': uid});
  }

  Stream<User> getUserStream(String uid) {
    return _db.collection('users').doc(uid).snapshots().map((doc) =>
        User.fromMap({...doc.data() as Map<String, dynamic>, 'uid': uid}));
  }

  Future<void> updateUserProfile(String uid, String name, String npm) async {
    await _db.collection('users').doc(uid).update({'name': name, 'npm': npm});
  }

  Stream<List<User>> getPendingMembers() {
    return _db
        .collection('users')
        .where('role', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => User.fromMap({...doc.data(), 'uid': doc.id}))
          .toList();
    });
  }

  Future<void> approveMember(String uid) async {
    await _db.collection('users').doc(uid).update({'role': 'member'});
  }

  Future<void> rejectMember(String uid) async {
    await _db.collection('users').doc(uid).delete();
  }

  // Material methods
  Future<void> createMaterial(String name, String description, String category,
      String photoUrl, String youtubeLink) async {
    await _db.collection('materials').add({
      'name': name,
      'description': description,
      'category': category,
      'photoUrl': photoUrl,
      'youtubeLink': youtubeLink,
    });
  }

  Stream<List<StudyMaterial>> getMaterials() {
    return _db.collection('materials').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => StudyMaterial.fromMap({'id': doc.id, ...doc.data()}))
          .toList();
    });
  }

  Future<void> updateMaterial(String id, String name, String description,
      String category, String youtubeLink) async {
    await _db.collection('materials').doc(id).update({
      'name': name,
      'description': description,
      'category': category,
      'youtubeLink': youtubeLink,
    });
  }

  Future<void> deleteMaterial(String id) async {
    await _db.collection('materials').doc(id).delete();
  }

  // Quiz methods
  Future<void> addQuizQuestion(
      String question, List<String> options, int correctOptionIndex) async {
    await _db.collection('quizzes').add({
      'question': question,
      'options': options,
      'correctOptionIndex': correctOptionIndex,
    });
  }

  Future<List<Quiz>> getQuizzes() async {
    QuerySnapshot snapshot = await _db.collection('quizzes').get();
    return snapshot.docs
        .map((doc) =>
            Quiz.fromMap({'id': doc.id, ...doc.data() as Map<String, dynamic>}))
        .toList();
  }
}
