import 'package:flutter/material.dart';
import 'package:qeydlerim/models/note.dart';

class View extends StatelessWidget {
  final Note note;
  View({this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
      ),
      body: Container(),
    );
  }
}
