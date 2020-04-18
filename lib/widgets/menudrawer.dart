import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qeydlerim/screens/archieved.dart';
import 'package:qeydlerim/screens/deleted.dart';

class MenuDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.black,
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text(
                "Qeydlərim",
                style: Theme.of(context)
                    .textTheme
                    .body1
                    .copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            InkWell(
              child: _listTile("Arxiv", context),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => Archieved()));
              },
            ),
            InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => Deleted()));
                },
                child: _listTile("Silinənlər", context)),
            // _listTile("Ayarlar", context),
          ],
        ),
      ),
    );
  }

  Widget _listTile(String text, context) => ListTile(
        leading: Icon(Icons.change_history, color: Colors.white70),
        title: Text(
          text,
          style:
              Theme.of(context).textTheme.body1.copyWith(color: Colors.white),
        ),
      );
}
