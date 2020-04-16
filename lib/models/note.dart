class Note {
  int _id;
  String _title;
  String _description;
  String _date;
  int _priority, _color;

  Note(this._title, this._date, this._priority, this._color,
      [this._description]);

  Note.withID(this._id, this._title, this._description, this._date,
      this._priority, this._color);

  int get id => _id;
  String get title => _title;
  String get description => _description;
  String get date => _date;
  int get priority => _priority;
  int get color => _color;

  set title(String title) {
    if (title.length <= 255) this._title = title;
  }

  set description(String description) {
    if (description.length <= 255) this.description = _description;
  }

  set priority(int priority) {
    if (priority >= 1 && priority <= 3) this._priority = priority;
  }

  set color(int color) {
    if (color >= 0 && color <= 9) this._color = color;
  }

  set date(String date) {
    this._date = date;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": _id,
      "title": _title,
      "description": _description,
      "priority": _priority,
      "color": _color,
      "date": _date,
    };
  }

  Note.fromMap(Map<String, dynamic> map) {
    this._id = map["id"];
    this._title = map["title"];
    this._description = map["description"];
    this._priority = map["priority"];
    this._color = map["color"];
    this._date = map["date"];
  }
}
