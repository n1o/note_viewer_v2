import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SyncedFolder extends ChangeNotifier {
  final String _FOLDER_KEY = "SELECTED_FOLDER";
  final String _EMPTY = "None";

  String _selectedFolder;

  String get selectedFolder => _selectedFolder ?? _EMPTY;

  ChangeNotifier() {
    _loadFromSharedPreferences();
  }

  void _loadFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String folder = prefs.getString(this._FOLDER_KEY);
    if(folder != null) {
      setFolder(folder);
    }
  }

  void _persistFolder (String folder) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(this._FOLDER_KEY, folder);
  }

  void setFolder(String folder) {
    _selectedFolder = folder;
    notifyListeners();
  }

  void updateFolder(String folder) {
    _selectedFolder = folder;
    _persistFolder(folder);
    notifyListeners();
  }
}