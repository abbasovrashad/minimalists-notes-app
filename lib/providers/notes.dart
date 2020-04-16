import 'package:flutter/foundation.dart';

class NotesProvider with ChangeNotifier {
  int axisCount = 2;

  void changeView() {
    axisCount = axisCount == 1 ? 2 : 1;
    notifyListeners();

  }
}
