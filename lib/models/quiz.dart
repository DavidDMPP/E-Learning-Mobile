class Quiz {
  final String id;
  final String question;
  final List<String> options;
  final int correctOptionIndex;

  Quiz({
    required this.id,
    required this.question,
    required this.options,
    required this.correctOptionIndex,
  });

  factory Quiz.fromMap(Map<String, dynamic> data) {
    return Quiz(
      id: data['id'] ?? '',
      question: data['question'] ?? '',
      options: List<String>.from(data['options'] ?? []),
      correctOptionIndex: data['correctOptionIndex'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctOptionIndex': correctOptionIndex,
    };
  }
}
