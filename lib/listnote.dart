class Note {
  final String title;
  final String body;

  Note({
    required this.title,
    required this.body,
  });

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      title: map['title'],
      body: map['body'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
    };
  }
}
