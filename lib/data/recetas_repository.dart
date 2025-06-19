import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chefsmart/data/models/receta_detail_response.dart';
import 'package:chefsmart/data/models/rectas_response.dart';

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
}