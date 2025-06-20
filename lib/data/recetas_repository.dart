import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chefsmart/data/models/receta_detail_response.dart';
import 'package:chefsmart/data/models/rectas_response.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecetasRepository {
  Future<RecetasResponse> fetchRecetas() async {
    final snapshot = await FirebaseFirestore.instance.collection('recetas').get();
    final recetas = snapshot.docs
        .map((doc) => RecetaDetailResponse.fromJson({
              ...doc.data(),
              'id': doc.id,
            }))
        .toList();
    return RecetasResponse(recetas: recetas);
  }

  Future<RecetasResponse> fetchRecetasPopulares() async {
    final snapshot = await FirebaseFirestore.instance.collection('recetas_populares').get();
    final List<RecetaDetailResponse> recetasPopulares = []; 

    for ( var doc in snapshot.docs) {
      final data = doc.data();
      final recetaRef = data['receta_id'];

      final recetaSnapshot = await recetaRef.get();

      if(recetaSnapshot.exists) {
        final recetaData = recetaSnapshot.data() as Map<String, dynamic>;
        recetasPopulares.add(RecetaDetailResponse.fromJson({
          ...recetaData,
          'id': recetaSnapshot.id,
        }));
      } else {
        throw Exception('Receta no encontrada: ${recetaRef.path}');
      }
    }

    return RecetasResponse(
      recetas: recetasPopulares
    );
  }

  Future<RecetasResponse> fetchRecetasNuevas() async {
    final snapshot = await FirebaseFirestore.instance.collection('recetas_nuevas')
      .orderBy('fecha', descending: true)
      .limit(5)
      .get();

    final List<RecetaDetailResponse> recetasNuevas = []; 

    for ( var doc in snapshot.docs) {
      final data = doc.data();
      final recetaRef = data['receta_id'];

      final recetaSnapshot = await recetaRef.get();

      if(recetaSnapshot.exists) {
        final recetaData = recetaSnapshot.data() as Map<String, dynamic>;
        recetasNuevas.add(RecetaDetailResponse.fromJson({
          ...recetaData,
          'id': recetaSnapshot.id,
        }));
      } else {
        throw Exception('Receta no encontrada: ${recetaRef.path}');
      }
    }

    return RecetasResponse(
      recetas: recetasNuevas
    );
  }

  Future<RecetasResponse> fetchRecetasFavoritas() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Si no hay usuario autenticado, retorna lista vacía
      return RecetasResponse(recetas: []);
    }
    final idUsuario = user.uid;

    final snapshot = await FirebaseFirestore.instance
        .collection('favorito')
        .where('idusuario', isEqualTo: idUsuario)
        .get();

    final List<RecetaDetailResponse> recetasFavoritas = [];

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final recetaRef = data['idreceta'];
      if (recetaRef is DocumentReference) {
        final recetaSnapshot = await recetaRef.get();
        if (recetaSnapshot.exists) {
          final recetaData = recetaSnapshot.data() as Map<String, dynamic>;
          recetasFavoritas.add(RecetaDetailResponse.fromJson({
            ...recetaData,
            'id': recetaSnapshot.id,
          }));
        }
      }
    }

    return RecetasResponse(recetas: recetasFavoritas);
  }
}