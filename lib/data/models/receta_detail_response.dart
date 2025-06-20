class RecetaDetailResponse {
  final String id;
  final String region;
  final List<String> ingredientes; 
  final String titulo;
  final String video;

  RecetaDetailResponse({
    required this.id,
    required this.region,
    required this.ingredientes,
    required this.titulo,
    required this.video
   
  });

  factory RecetaDetailResponse.fromJson(Map<String, dynamic> json) {
    return RecetaDetailResponse(
      id: json['id']?.toString() ?? '',
      region: json['region']?.toString() ?? '',
      ingredientes: List<String>.from(json['ingredientes'] ?? []),
      titulo: json['titulo']?.toString() ?? '',
      video: json['video']?.toString() ?? '',
    );
  }
}