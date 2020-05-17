import 'package:flutter/material.dart';
import 'package:qeydlerim/models/note.dart';
import 'package:qeydlerim/providers/notes.dart';
import 'package:qeydlerim/services/database.dart';
import 'package:provider/provider.dart';
import 'package:qeydlerim/widgets/custom_toast.dart';

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
        appBar: _appBar(notesProvider),
        body: _body(notesProvider),
        bottomNavigationBar: _bottomAppBar(),
        floatingActionButton: notesProvider.showFAB
            ? _saveButton(notesProvider)
            : SizedBox.shrink(),
      ),
    );
  }

  Widget _body(notesProvider) => Container(
        margin: const EdgeInsets.all(15.0),
        child: TextField(
          onTap: () => notesProvider.showFAB = true,
          controller: descriptionController,
          onChanged: (description) => notesProvider.description = description,
          style: Theme.of(context).textTheme.body1,
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
          maxLines: (MediaQuery.of(context).size.height).ceil(),
        ),
      );

  BottomAppBar _bottomAppBar() => BottomAppBar(
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
      );

  FloatingActionButton _saveButton(notesProvider) =>
      FloatingActionButton.extended(
        backgroundColor: Colors.black,
        onPressed: () => _update(notesProvider),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        label: Icon(Icons.save),
      );

  AppBar _appBar(notesProvider) => AppBar(
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
      );

  void _share(Note note) {
    // TODO: add share functionality
  }

  void _archieve(int id) async {
    final result = await databaseService.archieveNote(id);
    if (result != null) {
      CustomToast.display(text: "NOTE ARCHIVED");
      Navigator.of(context).popUntil(ModalRoute.withName("/"));
    }
  }

  void _unarchieve(int id) async {
    final result = await databaseService.unarchieveNote(id);
    if (result != null) {
      Navigator.pop(context);
      CustomToast.display(text: "NOTE UNARCHIVED");
    }
  }

  void _deleteDialog(int id, int isDeleted) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "SURE TO DELETE THE NOTE?",
            textAlign: TextAlign.center,
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Text("NO", style: Theme.of(context).textTheme.body1),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton(
                color: Colors.black,
                child: Text(
                  "YES",
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
      widget.note.isDeleted,
    );

    final result = await databaseService.update(updatedNote);
    if (result != null) {
      CustomToast.display(text: "CHANGES SAVED", positive: true);
    }
  }

  void _delete(int id, int isDeleted) async {
    if (isDeleted == 0) {
      final result = await databaseService.moveToDeletedNotes(id);
      if (result != null) {
        CustomToast.display(text: "NOTE MOVED TO DELETEDS");
        Navigator.of(context).popUntil(ModalRoute.withName("/"));
      }
    } else {
      final result = await databaseService.deleteCompletely(id);
      if (result != null) {
        CustomToast.display(text: "NOTE DELETED PERMANENTLY");
        Navigator.of(context).popUntil(ModalRoute.withName("/"));
      }
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
