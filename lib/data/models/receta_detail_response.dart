class RecetaDetailResponse {
  final String id;
  final List<String> clasificacionOrigen;
  final List<String> imagenes;
  final List<String> ingredientes; 
  final String nombre; 
  final String pais; 
  final List<String> region; 
  final List<String> pasos; 
  final bool? populares; 
  final bool? nuevo; 

  RecetaDetailResponse({
    required this.id,
    required this.clasificacionOrigen,
    required this.imagenes,
    required this.ingredientes,
    required this.nombre,
    required this.pais,
    required this.region,
    required this.pasos,
    this.populares,
    this.nuevo,
  });

  factory RecetaDetailResponse.fromJson(Map<String, dynamic> json) {
    return RecetaDetailResponse(
      id: json['id'] as String,
      clasificacionOrigen: List<String>.from(json['clasificacionOrigen'] ?? []),
      imagenes: List<String>.from(json['imagenes'] ?? []),
      ingredientes: List<String>.from(json['ingredientes'] ?? []),
      nombre: json['nombre'] as String,
      pais: json['pais'] as String,
      region: List<String>.from(json['region'] ?? []),
      pasos: List<String>.from(json['pasos'] ?? []),
      populares: json['populares'] as bool?,
      nuevo: json['nuevo'] as bool?,
    );
  }
}