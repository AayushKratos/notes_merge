class NotesImpNames {
  static String id = "id";
  static String pin = "pin";
  static String title = "title";
  static String content = "content";
  static String createdTime = "createdTime";
  static String archived = "archived";
  static String TableName = "Notes";
  static String fireID = "FireID";
  static List<String> values = [id, pin, title, content, createdTime, archived];
}

class Note {
  int? id;
  bool pin;
  String title;
  String content;
  DateTime? createdTime;
  bool archived;
  String fireId;

  Note({
    this.id,
    required this.pin,
    required this.title,
    required this.content,
    required this.createdTime,
    required this.archived,
    required this.fireId,
  });

  Note copy({
    int? id,
    bool? pin,
    String? title,
    String? content,
    DateTime? createdTime,
    bool? archived,
    String? fireId,
  }) {
    return Note(
      id: id ?? this.id,
      pin: pin ?? this.pin,
      title: title ?? this.title,
      content: content ?? this.content,
      createdTime: createdTime ?? this.createdTime,
      archived: archived ?? this.archived,
      fireId: fireId ?? this.fireId,
    );
  }

  static Note fromJson(Map<String, Object?> json) {
    return Note(
        id: json[NotesImpNames.id] as int?,
        pin: json[NotesImpNames.pin] == 1,
        title: json[NotesImpNames.title] as String,
        content: json[NotesImpNames.content] as String,
        createdTime: DateTime.parse(
          json[NotesImpNames.createdTime] as String,
        ),
        archived: json[NotesImpNames.archived] == 1,
        fireId: json[NotesImpNames.fireID] as String,
        );
  }

  Map<String, Object?> toJson() {
    return {
      NotesImpNames.id: id,
      NotesImpNames.pin: pin ? 1 : 0,
      NotesImpNames.title: title,
      NotesImpNames.content: content,
      NotesImpNames.createdTime: createdTime!.toIso8601String(),
      NotesImpNames.archived: archived ? 1 : 0,
      NotesImpNames.fireID: fireId,
    };
  }
}
