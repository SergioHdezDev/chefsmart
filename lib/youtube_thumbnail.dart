class YouTubeThumbnail {
  /// Obtiene la URL de la miniatura de un video de YouTube.
  ///
  /// - [videoUrl]: URL del video (ej: "https://youtu.be/WOvKU6iAr_0").
  /// - [quality]: Calidad de la miniatura (por defecto: '0').
  ///   Opciones comunes: '0', '1', '2', 'hqdefault', 'sddefault', 'maxresdefault'.
  static String getThumbnail(String videoUrl, {String quality = '0'}) {
    final videoId = _extractVideoId(videoUrl);
    return 'https://img.youtube.com/vi/$videoId/$quality.jpg';
  }

  /// Extrae el ID del video desde una URL de YouTube.
  static String _extractVideoId(String videoUrl) {
    final RegExp regExp = RegExp(
      r'.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?.*v=))([^#&?]*).*',
      caseSensitive: false,
    );

    final match = regExp.firstMatch(videoUrl);
    final videoId = (match != null && match.groupCount >= 7) ? match.group(7) : null;

    if (videoId == null || videoId.isEmpty) {
      throw ArgumentError('URL de YouTube no válida: "$videoUrl"');
    }

    return videoId;
  }
}