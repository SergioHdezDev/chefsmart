import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final Logger _logger = Logger();

  // Guardar datos del usuario en Firestore
  Future<void> saveUserData(String userId, Map<String, dynamic> userData) async {
    try {
      await _db.collection('users').doc(userId).set(userData);
      _logger.i('Datos del usuario guardados correctamente');
    } catch (e) {
      _logger.e('Error al guardar datos del usuario: $e');
    }
  }

  // Obtener datos del usuario
  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(userId).get();
      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      _logger.e('Error al obtener datos del usuario: $e');
      return null;
    }
  }

  // Actualizar datos del usuario
  Future<void> updateUserData(String userId, Map<String, dynamic> newData) async {
    try {
      await _db.collection('users').doc(userId).update(newData);
      _logger.i('Datos del usuario actualizados correctamente');
    } catch (e) {
      _logger.e('Error al actualizar datos del usuario: $e');
    }
  }

  Future<void> addData(String collection, Map<String, dynamic> data) async {
    try {
      await _db.collection(collection).add(data);
      _logger.i('Documento agregado correctamente');
    } catch (e) {
      _logger.e('Error al agregar documento: $e');
    }
  }

  Future<void> updateData(String collection, String docId, Map<String, dynamic> data) async {
    try {
      await _db.collection(collection).doc(docId).update(data);
      _logger.i('Documento actualizado correctamente');
    } catch (e) {
      _logger.e('Error al actualizar documento: $e');
    }
  }

  Future<void> deleteData(String collection, String docId) async {
    try {
      await _db.collection(collection).doc(docId).delete();
      _logger.i('Documento eliminado correctamente');
    } catch (e) {
      _logger.e('Error al eliminar documento: $e');
    }
  }
}