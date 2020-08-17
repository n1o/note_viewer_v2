import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class SyncedFolder extends ChangeNotifier {
  final String _FOLDER_KEY = "SELECTED_FOLDER";
  final LocalStorage storage  = new LocalStorage('folder');

  String _selectedFolder;

  String get selectedFolder {

    if (_selectedFolder != null) {
       _selectedFolder = storage.getItem(_FOLDER_KEY);
    } 

    return _selectedFolder;
  } 

  void setFolder(String folder) {
    _selectedFolder = folder;
    notifyListeners();
  }

  void updateFolder(String folder) {
    _selectedFolder = folder;
    storage.setItem(_FOLDER_KEY, folder);
    notifyListeners();
  }    
}
