import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_brand_icons/flutter_brand_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.black,
        child: Column(
          children: <Widget>[
            _drawerHeader(context),
            InkWell(
              child: _listTile("Archieve", context),
              onTap: () => Navigator.of(context).popAndPushNamed("/archieved"),
            ),
            InkWell(
              child: _listTile("Deleted", context),
              onTap: () => Navigator.of(context).popAndPushNamed("/deleted"),
            ),
            InkWell(
              child: _listTile("Settings", context),
              onTap: () => Navigator.of(context).popAndPushNamed("/settings"),
            ),
            Spacer(),
            _repoLink(),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  Widget _drawerHeader(BuildContext context) {
    return DrawerHeader(
      child: Text(
        "minimalist's notes",
        style: Theme.of(context).textTheme.body1.copyWith(color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _repoLink() {
    return IconButton(
      icon: Icon(
        BrandIcons.github,
        color: Colors.white,
        size: 40.0,
      ),
      onPressed: () async {
        final repo = "https://github.com/kamranbekirovyz/minimalists-notes-app";
        if (await canLaunch(repo)) launch(repo);
      },
    );
  }

  Widget _listTile(String text, context) => ListTile(
        leading: Icon(Icons.change_history, color: Colors.white70),
        title: Text(
          text,
          style: Theme.of(context).textTheme.body1.copyWith(
                color: Colors.white,
              ),
        ),
      );
}
