import 'dart:io';

import 'package:flutter/material.dart';
import 'package:notes_viewer/pages/note_view.dart';
import 'package:notes_viewer/store/folder.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var folder = Provider.of<SyncedFolder>(context);

    return _body(folder.selectedFolder);
  }

  Widget _body(String folder) {
    if (folder == null) {
      return Center(
        child: Column(
          children: [Text("Select an folder")],
        ),
      );
    } else {
      Directory dir = new Directory("${folder}/notes");
      List<FileSystemEntity> files = dir.listSync();

      return ListView.builder(
          padding: EdgeInsets.all(15),
          itemCount: files.length,
          itemBuilder: (BuildContext context, int index) {
            FileSystemEntity entity = files[index];
            String name = entity.path.split("/").removeLast();
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => new NoteViewerPage(entity.path)));
                print(name);
              },
              child: Center(
                  child: Column(
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 16),
                  ),
                  Divider()
                ],
              )),
            );
          });
    }
  }
}
