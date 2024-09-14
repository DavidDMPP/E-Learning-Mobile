class StudyMaterial {
  final String id;
  final String name;
  final String description;
  final String category;
  final String photoUrl;
  final String youtubeLink;

  StudyMaterial({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.photoUrl,
    required this.youtubeLink,
  });

  factory StudyMaterial.fromMap(Map<String, dynamic> data) {
    return StudyMaterial(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      youtubeLink: data['youtubeLink'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'photoUrl': photoUrl,
      'youtubeLink': youtubeLink,
    };
  }
}
