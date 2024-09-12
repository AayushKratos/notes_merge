import 'package:flutter/material.dart';
import 'package:notes/colors.dart';
import 'package:notes/model/NoteModel.dart';
import 'package:notes/services/db.dart';

class CreateNoteView extends StatefulWidget {
  final VoidCallback onNoteCreated;

  const CreateNoteView({super.key, required this.onNoteCreated});

  @override
  State<CreateNoteView> createState() => _CreateNoteViewState();
}

class _CreateNoteViewState extends State<CreateNoteView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

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
            onPressed: _saveNote, // Call the save method
            icon: Icon(Icons.save_outlined),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            TextField(
              controller: _titleController, // Use the controller here
              cursorColor: white,
              style: TextStyle(fontSize: 25, color: white, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: 'Title',
                hintStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.withOpacity(0.8),
                ),
              ),
            ),
            Container(
              height: 300,
              child: TextField(
                controller: _contentController, // Use the controller here
                keyboardType: TextInputType.multiline,
                minLines: 50,
                maxLines: null,
                cursorColor: white,
                style: TextStyle(fontSize: 25, color: white),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: 'Note',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.withOpacity(0.8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveNote() async {
    final String title = _titleController.text;
    final String content = _contentController.text;

    if (title.isNotEmpty && content.isNotEmpty) {
      final note = Note(
        title: title,
        content: content,
        createdTime: DateTime.now(),
        pin: false,
        id: null,
        archived: false // id will be set by the database
      );

      // Insert the note into the database
      await NoteDatabase.instance.InsertEntry(note);

      // Go back to the Home screen and refresh the note list
      widget.onNoteCreated();
      Navigator.pop(context); // Or use Navigator.popUntil to return to a specific screen
    } else {
      // Optionally, show an error message if the title or content is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both title and content')),
      );
    }
  }
}
