import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Guardar datos del usuario en Firestore
  Future<void> saveUserData(String userId, Map<String, dynamic> userData) async {
    try {
      await _firestore.collection('users').doc(userId).set(userData);
    } catch (e) {
      print("Error al guardar datos del usuario: $e");
    }
  }

  // Obtener datos del usuario
  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(userId).get();
      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      print("Error al obtener datos del usuario: $e");
      return null;
    }
  }

  // Actualizar datos del usuario
  Future<void> updateUserData(String userId, Map<String, dynamic> newData) async {
    try {
      await _firestore.collection('users').doc(userId).update(newData);
    } catch (e) {
      print("Error al actualizar datos del usuario: $e");
    }
  }
}