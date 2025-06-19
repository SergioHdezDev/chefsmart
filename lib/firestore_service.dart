import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final Logger _logger = Logger();

  // ✅ Función para actualizar enlaces de video
  Future<void> actualizarVideos() async {
    Map<String, String> nuevosVideos = {
      "Bandeja Paisa": "https://www.youtube.com/watch?v=hTTARtHxKns",
      "Caldo de Costilla": "https://www.youtube.com/watch?v=dGJ4lgOIG5U",
      "Tamales Tolimenses":
          "https://www.youtube.com/watch?v=Xcbcn6Ohy6g&t=191s",
    };

    try {
      QuerySnapshot snapshot = await _db.collection("recetas").get();
      for (var doc in snapshot.docs) {
        String titulo = doc["titulo"];
        if (nuevosVideos.containsKey(titulo)) {
          await doc.reference.update({"video": nuevosVideos[titulo]});
          _logger.i("✅ Video actualizado para: $titulo");
        }
      }
      _logger.i("✅ Todos los enlaces de video han sido actualizados.");
    } catch (e) {
      _logger.e("❌ Error al actualizar videos: $e");
    }
  }
}
