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
    print(widget.note.isArchieved);
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
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.share, color: Colors.white),
                onPressed: () => _share(widget.note),
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.white),
                onPressed: () =>
                    _deleteDialog(widget.note.id, widget.note.isDeleted),
              ),
              IconButton(
                icon: Icon(
                    widget.note.isArchieved == 1
                        ? Icons.unarchive
                        : Icons.archive,
                    color: Colors.white),
                onPressed: () => widget.note.isArchieved == 1
                    ? _unarchieve(widget.note.id)
                    : _archieve(widget.note.id),
              ),
            ],
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

  void _share(Note note) {}

  void _archieve(int id) async {
    await databaseService.archieveNote(id);
    Navigator.pop(context);
    Fluttertoast.showToast(
      msg: "QEYD ARXİVLƏNDİ!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 18.0,
    );
  }

  void _unarchieve(int id) async {
    await databaseService.unarchieveNote(id);
    Navigator.pop(context);
    Fluttertoast.showToast(
      msg: "QEYD ARXİVDƏN ÇIXARILDI!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 18.0,
    );
  }

  void _deleteDialog(int id, int isDeleted) async {
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
                  _delete(id, isDeleted);
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
        widget.note.isArchieved,
        widget.note.isDeleted);

    databaseService.update(updatedNote);
    Fluttertoast.showToast(
      msg: "DƏYİŞİKLİKLƏR SAXLANILDI",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green[400],
      textColor: Colors.white,
      fontSize: 18.0,
    );
  }

  void _delete(int id, int isDeleted) async {
    if (isDeleted == 0) {
      await databaseService.moveToDeletedNotes(id);
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: "QEYD SİLİNƏNLƏRƏ DAŞINDI",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 18.0,
      );
    } else {
      await databaseService.deleteCompletely(id);
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: "QEYD SİLİNDİ",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 18.0,
      );
    }
  }
}
