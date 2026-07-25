import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SupportMessageService {
  SupportMessageService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  Future<void> submitMessage({
    required String username,
    required String email,
    required String message,
  }) async {
    final user = _auth.currentUser;
    await _firestore.collection('support_messages').add({
      'username': username.trim(),
      'email': email.trim(),
      'message': message.trim(),
      'userId': user?.uid,
      'userEmail': user?.email,
      'createdAt': FieldValue.serverTimestamp(),
      'status': 'open',
    });
  }
}
