import 'package:flutter/material.dart';
import 'package:notes/colors.dart';
import 'package:notes/model/NoteModel.dart';
import 'package:notes/services/db.dart';

class EditNoteView extends StatefulWidget {
  Note note;
  EditNoteView({required this.note});

  @override
  _EditNoteViewState createState() => _EditNoteViewState();
}

class _EditNoteViewState extends State<EditNoteView> {
  late String NewTitle;
  late String NewNoteDet;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NewTitle = widget.note.title.toString();
    NewNoteDet = widget.note.content.toString();
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
            onPressed: () async {
              // Create a new note object with the updated fields
              Note updatedNote = Note(
                  content: NewNoteDet,
                  title: NewTitle,
                  createdTime:
                      widget.note.createdTime, // Use the original creation time
                  pin: widget
                      .note.pin, // Keep the pin status unchanged (if relevant)
                  id: widget.note
                      .id, // Pass the original note ID to avoid creating a new note
                  archived: widget.note.archived
                  );

              // Update the note in the database
              await NoteDatabase.instance.updateNote(updatedNote);

              // Navigate to the NoteView screen
              Navigator.pop(
                context, updatedNote
              );
            },
            icon: Icon(Icons.save_outlined),
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            Form(
              child: TextFormField(
                initialValue: NewTitle,
                cursorColor: white,
                onChanged: (value) {
                  NewTitle = value;
                },
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: "Title",
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.withOpacity(0.8))),
              ),
            ),
            Container(
                height: 300,
                child: Form(
                  child: TextFormField(
                    onChanged: (value) {
                      NewNoteDet = value;
                    },
                    initialValue: NewNoteDet,
                    cursorColor: white,
                    keyboardType: TextInputType.multiline,
                    minLines: 50,
                    maxLines: null,
                    style: TextStyle(fontSize: 17, color: Colors.white),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: "Note",
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.withOpacity(0.8))),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
