import 'package:flutter/material.dart';
import 'package:notes/colors.dart';
import 'package:notes/model/NoteModel.dart';
import 'package:notes/pages/note_view.dart';
import 'package:notes/services/db.dart'; // Ensure to import your DB service

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  TextEditingController _searchController = TextEditingController();
  List<Note> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_searchNotes);
  }

  void _searchNotes() async {
    String query = _searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      List<Note> allNotes = await NoteDatabase.instance.readAllNotes();
      setState(() {
        _searchResults = allNotes
            .where((note) =>
                note.title.toLowerCase().contains(query) ||
                note.content.toLowerCase().contains(query))
            .toList();
      });
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(color: white.withOpacity(0.1)),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_outlined, color: white)),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(color: white),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: 'Search your notes',
                        hintStyle: TextStyle(color: white.withOpacity(0.5), fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    Note note = _searchResults[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NoteView(
                              note: note,
                              onNoteUpdated: () {
                                // Implement if needed
                              },
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(bottom: 10),
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
        ),
      ),
    );
  }
}
