import 'package:flutter/material.dart';
import 'package:notes/colors.dart';
import 'package:notes/model/NoteModel.dart';
import 'package:notes/pages/note_view.dart';
import 'package:notes/pages/side_menu.dart';
import 'package:notes/services/db.dart'; // Make sure this import is correct
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class ArchivePage extends StatefulWidget {
  const ArchivePage({Key? key}) : super(key: key);

  @override
  _ArchivePageState createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  bool isLoading = true;
  List<Note> archivedNotes = [];

  @override
  void initState() {
    super.initState();
    _fetchArchivedNotes();
  }

  Future<void> _fetchArchivedNotes() async {
    // Fetch only archived notes
    archivedNotes = await NoteDatabase.instance.getNotes(archived: true);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _unarchive(Note note) async {
    // Unarchive the note in the database
    final updatedNote = note.copy(archived: false);
    await NoteDatabase.instance.updateNote(updatedNote);

    // Refresh the list of archived notes
    _fetchArchivedNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0.0,
        title: Text('Archived Notes', style: TextStyle(color: white),),
        leading: IconButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => SideMenu()));}, icon: Icon(Icons.menu_outlined, color: white,)),
      ),
      drawer: SideMenu(),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.white))
          : StaggeredGridView.countBuilder(
              padding: EdgeInsets.all(10),
              crossAxisCount: 4,
              itemCount: archivedNotes.length,
              staggeredTileBuilder: (index) => StaggeredTile.fit(2),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              itemBuilder: (context, index) {
                final note = archivedNotes[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoteView(note: note, onNoteUpdated: () {},),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: white.withOpacity(0.4)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.title,
                          style: TextStyle(
                            color: white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          note.content.length > 100
                              ? '${note.content.substring(0, 100)}...'
                              : note.content,
                          style: TextStyle(color: white.withOpacity(0.8)),
                        ),
                        SizedBox(height: 8),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: IconButton(
                            icon: Icon(Icons.unarchive, color: Colors.red),
                            onPressed: () {
                              _unarchive(note);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
