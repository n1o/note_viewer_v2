import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:notes_viewer/store/folder.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    var folder = Provider.of<SyncedFolder>(context);

    void _select() async {
      String file = await FilePicker.getDirectoryPath();

      setState(() {
        folder.updateFolder(file);
      });
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          
          Row(
            children: [ 
              Padding( 
                padding: EdgeInsets.only(left: 10),
                child: Text("Selected: ", 
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),)
              ),
              Text(folder.selectedFolder ?? "None")],),
          RaisedButton(
            onPressed: _select,
            child: Text("Change"),
          )
        ],
      ),
    );
  }
}
