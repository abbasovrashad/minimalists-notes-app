import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qeydlerim/models/note.dart';
import 'package:qeydlerim/providers/notes.dart';
import 'package:qeydlerim/services/database.dart';
import 'package:provider/provider.dart';

class View extends StatefulWidget {
  final Note note;
  View({this.note});
  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<View> {
  DatabaseService databaseService = new DatabaseService();
  TextEditingController titleController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.note.title;
    descriptionController.text = widget.note.description;
    Provider.of<NotesProvider>(context, listen: false).showFAB = false;
  }

  @override
  Widget build(BuildContext context) {
    var notesProvider = Provider.of<NotesProvider>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: TextField(
            onTap: () => notesProvider.showFAB = true,
            style: Theme.of(context).textTheme.body1,
            onChanged: (title) => notesProvider.title = title,
            controller: titleController,
            decoration: InputDecoration(
              hintStyle: Theme.of(context)
                  .textTheme
                  .body1
                  .copyWith(color: Colors.black54),
              border: InputBorder.none,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.delete_forever,
                color: Colors.black,
              ),
              onPressed: () => _deleteDialog(widget.note.id),
            ),
          ],
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: Container(
          margin: const EdgeInsets.all(15.0),
          child: TextField(
            onTap: () => notesProvider.showFAB = true,
            controller: descriptionController,
            onChanged: (description) => notesProvider.description = description,
            style: Theme.of(context).textTheme.body1,
            decoration: InputDecoration(
              hintText: "qeydiniz..",
              hintStyle: Theme.of(context)
                  .textTheme
                  .body1
                  .copyWith(color: Colors.black54),
              border: InputBorder.none,
            ),
            maxLines: (MediaQuery.of(context).size.height).ceil(),
            // decoration: ,
          ),
        ),
        floatingActionButton: notesProvider.showFAB
            ? FloatingActionButton.extended(
                backgroundColor: Colors.black,
                onPressed: () => _update(notesProvider),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                label: Icon(Icons.save),
              )
            : SizedBox.shrink(),
      ),
    );
  }

  void _deleteDialog(int id) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "QEYD SİLİNSİN?",
            textAlign: TextAlign.center,
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Text("xeyr", style: Theme.of(context).textTheme.body1),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton(
                color: Colors.black,
                child: Text(
                  "bəli",
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(color: Colors.white),
                ),
                onPressed: () {
                  _delete(id);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        );
      },
    );
  }

  void _update(notesProvider) async {
    Note updatedNote = new Note.withID(
      widget.note.id,
      titleController.text,
      descriptionController.text,
      widget.note.date,
      1,
    );

    databaseService.update(updatedNote);
    Fluttertoast.showToast(
      msg: "DƏYİŞİKLİKLƏR SAXLANILDI!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green[400],
      textColor: Colors.white,
      fontSize: 18.0,
    );
  }

  void _delete(int id) async {
    databaseService.delete(id);
    Fluttertoast.showToast(
      msg: "QEYD SİLİNDİ!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green[400],
      textColor: Colors.white,
      fontSize: 18.0,
    );
  }
}
