import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qeydlerim/providers/notes.dart';
import 'package:qeydlerim/screens/add.dart';
import 'package:qeydlerim/widgets/menudrawer.dart';

class Home extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final List notes = ["salam", "aleykum", "necesen"];

  @override
  Widget build(BuildContext context) {
    var notesProvider = Provider.of<NotesProvider>(context);
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: MenuDrawer(),
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.sort, color: Colors.black),
            onPressed: () => _scaffoldKey.currentState.openDrawer(),
          ),
          backgroundColor: Colors.white,
          title: Text(
            "Qeydlərim",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          elevation: 0.0,
          actions: notes.isEmpty
              ? <Widget>[]
              : <Widget>[
                  IconButton(
                    icon: Icon(
                      notesProvider.axisCount == 2
                          ? Icons.view_headline
                          : Icons.view_comfy,
                      color: Colors.black,
                    ),
                    onPressed: () => notesProvider.changeView(),
                  ),
                  IconButton(
                    icon: Icon(Icons.search, color: Colors.black),
                    onPressed: () {},
                  ),
                ],
        ),
        body: notes.length == 0
            ? Center(
                child: Text(
                  "Qeydləriniz yoxdur.",
                  style: Theme.of(context).textTheme.body1,
                ),
              )
            : displayNotes(notesProvider),
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          tooltip: "Əlavə et",
          child: Icon(Icons.add),
          onPressed: () => Navigator.push(
              context, CupertinoPageRoute(builder: (context) => Add())),
        ),
      ),
    );
  }

  Widget displayNotes(notesProvider) => GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: notesProvider.axisCount,
          childAspectRatio: 3.0,
        ),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            color: index % 2 == 0 ? Colors.grey[100] : Colors.grey[50],
            child: Text(notes[index]),
          );
        },
      );
}
