import 'package:flutter/material.dart';
import 'package:notes_viewer/pages/notes_list.dart';
import 'package:notes_viewer/pages/random_note.dart';
import 'package:notes_viewer/pages/settings.dart';
import 'package:provider/provider.dart';

import 'model/model.dart';
import 'store/folder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final initialized = await MyDbModel().initializeDB();
  if (initialized) {
    runApp(ChangeNotifierProvider(
      create: (context) => SyncedFolder(),
      child: MyApp(),
    ));
  } else {
    print("Error!");
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: RootPage(title: "Notes"));
  }
}

class RootPage extends StatefulWidget {
  RootPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _selectedIndex = 0;

  void _onItemTaped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _body(int index) {
    switch (index) {
      case 0:
        return new NotesPage();
      case 1:
        return new RandomNotePage();
      case 2:
        return new SettingsPage();
      default:
        return new NotesPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    var folder = Provider.of<SyncedFolder>(context);
    print(folder.selectedFolder);
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: _body(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
          BottomNavigationBarItem(icon: Icon(Icons.question_answer), title: Text("Random")),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), title: Text("Settings")),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTaped,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
