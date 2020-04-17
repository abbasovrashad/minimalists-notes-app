import 'package:flutter/foundation.dart';

class NotesProvider with ChangeNotifier {
  String title;
  String description;
  bool showFAB = false;

  void nullify(){
    title = null;
    description = null;
    showFAB = false;
  }
}
