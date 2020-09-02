
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:notes_viewer/store/folder.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'note_view.dart';

class RandomNotePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RandomNotePageState();
}

class _RandomNotePageState extends State<RandomNotePage> {
  _RandomNotePageState() {
    _rng = new Random();
  }
  List<FileSystemEntity> _notes;
  int selectedIndex;
  Random _rng;

  void _randomSequencePress() {
    final index = this._rng.nextInt(this._notes.length - 1);
    this.setState(() {
      this.selectedIndex = index;
    });
    final entity = this._notes[index];

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => new NoteViewerPage(entity.path),
        ));
  }

  @override
  Widget build(BuildContext context) {
    var folder = Provider.of<SyncedFolder>(context);

    if (this._notes == null && folder.selectedFolder != null) {
      Directory dir = new Directory("${folder.selectedFolder}/notes");
      this.setState(() {
        this._notes = dir.listSync();
      });
    }

    if (this._notes != null) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(children: [
            Text("${this._notes.length} Notes", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: RaisedButton(
                  onPressed: _randomSequencePress,
                  child: Text("Random"),
                ),
              ),
            )
          ]),
        ),
      );
    } else {
      return Center(
        child: Column(
          children: [Text("Select an folder")],
        ),
      );
    }
  }
}
