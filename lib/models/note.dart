class Note {
  int _id;
  String _title;
  String _description;
  String _date;
  int _priority;
  int _isArchieved;
  int _isDeleted;

  Note(
    this._title,
    this._description,
    this._date,
    this._priority,
    this._isArchieved,
    this._isDeleted,
  );

  Note.withID(
    this._id,
    this._title,
    this._description,
    this._date,
    this._priority,
    this._isArchieved,
    this._isDeleted,
  );

  int get id => _id;
  String get title => _title;
  String get description => _description;
  String get date => _date;
  int get priority => _priority;
  int get isDeleted => _isDeleted;
  int get isArchieved => _isArchieved;

  set title(String title) {
    if (title.length <= 255) this._title = title;
  }

  set description(String description) {
    if (description.length <= 255) this.description = _description;
  }

  set color(int priority) {
    if (priority >= 0 && priority <= 3) this._priority = priority;
  }

  set date(String date) {
    this._date = date;
  }

  set isArchieved(int oneOrZero){
    this._isArchieved = oneOrZero;
  }

  set isDeleted(int oneOrZero){
    this._isDeleted = oneOrZero;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": _id,
      "title": _title,
      "description": _description,
      "priority": _priority,
      "date": _date,
      "is_archieved": _isArchieved,
      "is_deleted": _isDeleted
    };
  }

  Note.fromMap(Map<String, dynamic> map) {
    this._id = map["id"];
    this._title = map["title"];
    this._description = map["description"];
    this._priority = map["priority"];
    this._date = map["date"];
    this._isArchieved = map["is_archieved"];
    this._isDeleted = map["is_deleted"];
  }
  
  @override 
  String toString() => "$id, $title, $description, $date, $priority, $isArchieved, $isDeleted";

}
