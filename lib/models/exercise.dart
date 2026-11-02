class Exercise {
  final String id;
  final String name;
  final String bodyPart;
  final String target;
  final String equipment;
  final String instructions;
  final String? imageUrl;

  Exercise({
    required this.id,
    required this.name,
    required this.bodyPart,
    required this.target,
    required this.equipment,
    required this.instructions,
    this.imageUrl,
  });

  // Membersihkan tag HTML dari instruksi API.
  static String cleanHtml(String? html) {
    if (html == null || html.isEmpty) return '';

    return html
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'</p>', caseSensitive: false), '\n\n')
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .trim();
  }

  factory Exercise.fromJson(Map<String, dynamic> json) {
    final translations = json['translations'] as List? ?? [];

    // Mengambil terjemahan bahasa Inggris jika tersedia.
    final translation = translations.firstWhere(
          (item) => item['language'] == 2,
      orElse: () => translations.isNotEmpty
          ? translations.first
          : <String, dynamic>{},
    );

    final category = json['category'] as Map<String, dynamic>? ?? {};
    final muscles = json['muscles'] as List? ?? [];
    final equipmentList = json['equipment'] as List? ?? [];
    final images = json['images'] as List? ?? [];

    final image = images.isNotEmpty ? images.first : null;

    return Exercise(
      id: json['id']?.toString() ?? '',
      name: translation['name'] ?? 'Unnamed Exercise',
      bodyPart: category['name'] ?? 'Other',
      target: muscles
          .map((item) => item['name_en'] ?? item['name'] ?? '')
          .where((name) => name.toString().isNotEmpty)
          .join(', '),
      equipment: equipmentList
          .map((item) => item['name'] ?? '')
          .where((name) => name.toString().isNotEmpty)
          .join(', '),
      instructions: cleanHtml(
        translation['description']?.toString(),
      ),
      imageUrl: image is Map ? image['image']?.toString() : null,
    );
  }
}
