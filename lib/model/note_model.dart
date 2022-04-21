class Note {
  int? id;
  String title;
  String body;
  DateTime date;

  Note({this.id, required this.title, required this.body, required this.date});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    if (id != null) {
      map['id'] = id;
    }
    map['title'] = title;
    map['body'] = body;
    map['date'] = date.toString();
    return map;
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
        id: map['id'],
        title: map['title'],
        body: map['body'],
        date: DateTime.parse(map['date']));
  }
}
