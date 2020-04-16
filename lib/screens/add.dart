import 'package:flutter/material.dart';
import 'package:qeydlerim/services/database.dart';

class Add extends StatelessWidget {
  DatabaseService databaseHelper = new DatabaseService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: TextField(
            decoration: InputDecoration(
              hintText: "başlıq",
              hintStyle: Theme.of(context).textTheme.body1,
              border: InputBorder.none,
            ),
          ),
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: Container(
          margin: const EdgeInsets.all(10.0),
          child: TextField(
            style: Theme.of(context).textTheme.body1,
            decoration: InputDecoration(
              hintText: "qeydiniz..",
              hintStyle: Theme.of(context).textTheme.body1.copyWith(color: Colors.black54),
              border: InputBorder.none,
            ),
            maxLines: (MediaQuery.of(context).size.height).ceil(),
            // decoration: ,
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          icon: Icon(Icons.save),
          label: Text("ƏLAVƏ ET"),
        ),
      ),
    );
  }
}
