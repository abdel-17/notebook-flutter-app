class Note {
  static const tableName = 'notes';

  final int id;
  final String title;
  final String content;
  final DateTime createdAt;

  const Note({
    this.id = 0,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> result = {
      'title': title,
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };
    if (id != 0) {
      // 0 is treated as unset.
      result['id'] = id;
    }
    return result;
  }
}
