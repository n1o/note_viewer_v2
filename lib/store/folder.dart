import 'package:flutter/material.dart';
import 'package:notes_viewer/model/model.dart';
// import 'package:localstorage/localstorage.dart';

class SyncedFolder extends ChangeNotifier {
  String _selectedFolder;
  SyncedFolder() {
    initialize();
  }

  void initialize() async {
    if (this._selectedFolder == null) {
      var storageItem = await Storage().getById(0);
      if (storageItem != null) {
        this._selectedFolder = storageItem.path;
        notifyListeners();
      }
    }
  }

  String get selectedFolder {
    return _selectedFolder;
  }

  void updateFolder(String folder) async  {
    _selectedFolder = folder;
    await Storage.withId(0, folder, false).save();
    notifyListeners();
  }
}
