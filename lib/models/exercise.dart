class Exercise {
  final String id;
  final String name;
  final String bodyPart;
  final String target;
  final String equipment;
  final String? instructions;
  final String? gifUrl;

  Exercise({
    required this.id,
    required this.name,
    required this.bodyPart,
    required this.target,
    required this.equipment,
    this.instructions,
    this.gifUrl,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      bodyPart: json['bodyPart'] ?? '',
      target: json['target'] ?? '',
      equipment: json['equipment'] ?? '',
      instructions: json['instructions'] is List
          ? (json['instructions'] as List).join('\n')
          : json['instructions']?.toString(),
      gifUrl: json['gifUrl'],
    );
  }
}
