import 'package:flutter/material.dart';
import 'package:notes/colors.dart';
import 'package:notes/model/NoteModel.dart';
import 'package:notes/pages/edit_note_view.dart';
import 'package:notes/services/db.dart';

class NoteView extends StatefulWidget {
  final Note note;
  final void Function() onNoteUpdated; // Correctly define the callback

  const NoteView({
    Key? key,
    required this.note,
    required this.onNoteUpdated, // Ensure this is used in the constructor
  }) : super(key: key);

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0.0,
        actions: [
          IconButton(
            splashRadius: 17,
            onPressed: () async {
              final updatedNote = widget.note.copy(pin: !widget.note.pin);
              await NoteDatabase.instance.updateNote(updatedNote);
              setState(() {
                widget.note.pin = updatedNote.pin; // Update the pin status
              });
            },
            icon: Icon(
              widget.note.pin ? Icons.push_pin : Icons.push_pin_outlined,
              color: widget.note.pin ? Colors.yellow : Colors.grey,
            ),
          ),
          IconButton(
            splashRadius: 17,
            onPressed: _toggleArchive,
            icon: Icon(
              widget.note.archived ? Icons.unarchive_outlined : Icons.archive_outlined,
            ),
          ),
          IconButton(
            splashRadius: 17,
            onPressed: () async {
              // Navigate to EditNoteView to edit the note
              final updatedNote = await Navigator.push<Note>(
                context,
                MaterialPageRoute(
                  builder: (context) => EditNoteView(note: widget.note),
                ),
              );

              // Check if the note is updated and set the state
              if (updatedNote != null) {
                setState(() {
                  widget.note.title = updatedNote.title;
                  widget.note.content = updatedNote.content;
                });
                widget.onNoteUpdated(); // Notify that the note has been updated
              }
            },
            icon: Icon(Icons.edit_outlined),
          ),
          IconButton(
            splashRadius: 17,
            onPressed: _deleteNote,
            icon: Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.note.title,
              style: TextStyle(
                color: white,
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              widget.note.content,
              style: TextStyle(color: white),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleArchive() async {
    Note updatedNote = widget.note.copy(archived: !widget.note.archived);
    await NoteDatabase.instance.updateNote(updatedNote);
    widget.onNoteUpdated(); // Notify that the note has been updated
    Navigator.pop(context, true); // Pass true to indicate a change
  }

  void _deleteNote() async {
    await NoteDatabase.instance.delteNote(widget.note);
    Navigator.pop(context); // Go back to the previous screen
  }
}
