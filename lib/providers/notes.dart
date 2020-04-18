import 'package:flutter/foundation.dart';
import 'package:qeydlerim/models/note.dart';

class NotesProvider with ChangeNotifier {
  String title;
  String description;
  bool showFAB = false;

  void nullify(){
    title = null;
    description = null;
    showFAB = false;
  }

  List<Note> notes = new List<Note>();
  List<Note> archievedNotes = new List<Note>();
}
