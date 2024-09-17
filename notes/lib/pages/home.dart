import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/colors.dart';
import 'package:notes/model/NoteModel.dart';
import 'package:notes/pages/create_note_view.dart';
import 'package:notes/pages/note_view.dart';
import 'package:notes/pages/search_page.dart';
import 'package:notes/pages/side_menu.dart';
import 'package:notes/services/db.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = true;
  bool isGridView = true;
  late List<Note> notesList = [];
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  String note =
      "THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE";
  String note1 = "THIS IS NOTE THIS IS NOTE THIS IS NOTE";
  @override
  void initState() {
    // TODO: implement initState
    _fetchNotes();
    super.initState();
    // getAllNotes();
  }

  Future<void> _logout() async {
  try {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/login'); // Redirect to login page
  } catch (e) {
    // Handle errors here
    print('Logout error: $e');
  }
}

  Future createEntry(Note note) async {
    await NoteDatabase.instance.InsertEntry(note);
  }

  Future getAllNotes() async {
    
    setState(() {
      isLoading = false;
    });
  }

  Future getOneNote(int id) async {
    await NoteDatabase.instance.readOneNote(id);
  }

  Future updateOneNote(Note note) async {
    await NoteDatabase.instance.updateNote(note);
  }

  Future deleteNote(Note note) async {
    await NoteDatabase.instance.delteNote(note);
  }

  Future<void> _fetchNotes() async {
    List<Note> notes = await NoteDatabase.instance.getNotes(archived: false);
    notesList = notes;
    // Custom Listsorting: pinned notes come first
      notes.sort((a, b) {
      if (a.pin && !b.pin) return -1; // a is pinned, b is not
      if (!a.pin && b.pin) return 1; // a is not pinned, b is
      return 0; // both are either pinned or not pinned
    });
    
     if(mounted){
    setState(() {
      isLoading = false;
    });
     }

  }

  void _refreshNotes() {
    _fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            backgroundColor: bgColor,
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          )
        : Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateNoteView(onNoteCreated: () {
                              getAllNotes();
                            })));
              },
              backgroundColor: cardColor,
              child: Icon(
                Icons.add,
                size: 45,
              ),
            ),
            endDrawerEnableOpenDragGesture: true,
            key: _drawerKey,
            drawer: SideMenu(),
            backgroundColor: bgColor,
            body: SafeArea(
                child: SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        width: MediaQuery.of(context).size.width,
                        height: 55,
                        decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                  color: black.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 3)
                            ]),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        _drawerKey.currentState!.openDrawer();
                                      },
                                      icon: Icon(
                                        Icons.menu,
                                        color: white,
                                      )),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SearchView()));
                                    },
                                    child: Container(
                                        height: 55,
                                        width: 200,
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Search Your Notes",
                                                style: TextStyle(
                                                    color:
                                                        white.withOpacity(0.5),
                                                    fontSize: 16),
                                              )
                                            ])),
                                  )
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  children: [
                                    TextButton(
                                        style: ButtonStyle(
                                            overlayColor:
                                                MaterialStateColor.resolveWith(
                                                    (states) =>
                                                        white.withOpacity(0.1)),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                            ))),
                                        onPressed: () {
                                          setState(() {
                                            isGridView = !isGridView;
                                          });
                                        },
                                        child: Icon(
                                          Icons.grid_view,
                                          color: white,
                                        )),
                                    SizedBox(
                                      width: 9,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        _logout();
                                      },
                                      child: CircleAvatar(
                                        radius: 16,
                                        backgroundColor: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ])),
                    isGridView ? NoteSectionAll() : NoteListSection(),
                  ],
                ),
              ),
            )));
  }

  Widget NoteSectionAll() {
    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "ALL",
                  style: TextStyle(
                      color: white.withOpacity(0.5),
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: StaggeredGridView.countBuilder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: notesList.where((note) => !note.archived).length,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              crossAxisCount: 4,
              staggeredTileBuilder: (index) => StaggeredTile.fit(2),
              itemBuilder: (context, index) {
                Note note =
                    notesList.where((note) => !note.archived).toList()[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            NoteView(note: note, onNoteUpdated: _refreshNotes),
                      ),
                    ).then((_) {
                      _fetchNotes(); // Refresh notes list
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(color: white.withOpacity(0.4)),
                        borderRadius: BorderRadius.circular(7)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(note.title,
                            style: TextStyle(
                                color: white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Text(
                          note.content.length > 250
                              ? "${note.content.substring(0, 250)}..."
                              : note.content,
                          style: TextStyle(color: white),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget NoteListSection() {
  return Container(
    child: Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "ALL",
                style: TextStyle(
                    color: white.withOpacity(0.5),
                    fontSize: 13,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(), // Disables scrolling
            shrinkWrap: true, // Uses only the space required by the list
            itemCount: notesList.where((note) => !note.archived).length,
            itemBuilder: (context, index) {
              Note note = notesList.where((note) => !note.archived).toList()[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          NoteView(note: note, onNoteUpdated: _refreshNotes),
                    ),
                  ).then((_) {
                    _fetchNotes(); // Refresh notes list
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(bottom: 10), // Add spacing between items
                  decoration: BoxDecoration(
                      border: Border.all(color: white.withOpacity(0.4)),
                      borderRadius: BorderRadius.circular(7)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(note.title,
                          style: TextStyle(
                              color: white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text(
                        note.content.length > 250
                            ? "${note.content.substring(0, 250)}..."
                            : note.content,
                        style: TextStyle(color: white),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}

  
}
