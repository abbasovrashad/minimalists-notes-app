import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qeydlerim/models/note.dart';
import 'package:qeydlerim/screens/view.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  NoteCard({this.note});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, CupertinoPageRoute(builder: (context) => View(note: note))),
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.orange[50],
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                note.title == null || note.title.isEmpty
                    ? SizedBox.shrink()
                    : Text(note.title),
                SizedBox(height: 5.0),
                Text(note.description ?? "",
                    style: Theme.of(context).textTheme.body2),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    DateFormat("H:m - dd MMM, yyyy")
                        .format(DateTime.parse(note.date)),
                    style: TextStyle(fontSize: 15.0),
                  ),
                ),
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
