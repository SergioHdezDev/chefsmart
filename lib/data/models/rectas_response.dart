import 'package:chefsmart/data/models/receta_detail_response.dart';

class RecetasResponse {
  final List<RecetaDetailResponse> recetas; 

  RecetasResponse({required this.recetas});

  factory RecetasResponse.fromJson(Map<String, dynamic> json) {
    var recetasList = json['recetas'] as List<dynamic>? ?? [];
    List<RecetaDetailResponse> recetas = recetasList
        .map((receta) => RecetaDetailResponse.fromJson(receta as Map<String, dynamic>))
        .toList();

    return RecetasResponse(recetas: recetas);
  }
}