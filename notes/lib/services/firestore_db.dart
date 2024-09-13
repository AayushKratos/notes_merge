import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes/model/NoteModel.dart';
import 'db.dart';

class FireDB {
  //CREATE,READ,UPDATE,DELETE
  final FirebaseAuth _auth = FirebaseAuth.instance;

  createNewNoteFirestore(Note note) async {
  final User? current_user = _auth.currentUser;

  if (current_user != null) {
    await FirebaseFirestore.instance
        .collection("notes")
        .doc(current_user.email) // No need for `!` anymore
        .collection("usernotes")
        .doc(note.id.toString())
        .set({
      "Title": note.title,
      "content": note.content,
      "date": note.createdTime,
    }).then((_) {
      print("DATA ADDED SUCCESSFULLY");
    });
  } else {
    print("Error: User is not logged in.");
  }
}


  getAllStoredNotes() async {
    final User? current_user = _auth.currentUser;
    await FirebaseFirestore.instance
        .collection("notes")
        .doc(current_user!.email)
        .collection("usernotes")
        .orderBy("date")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        Map note = result.data();

        NoteDatabase.instance.InsertEntry(Note(
            title: note["Title"],
            content: note["content"],
            createdTime: note["date"],
            pin: false,
            archived: false)); //Add Notes In Database
      });
    });
  }

  updateNoteFirestore(Note note) async {
    final User? current_user = _auth.currentUser;
    await FirebaseFirestore.instance
        .collection("notes")
        .doc(current_user!.email)
        .collection("usernotes")
        .doc(note.id.toString())
        .update({"title": note.title.toString(), "content": note.content}).then(
            (_) {
      print("DATA ADDED SUCCESFULLY");
    });
  }

  deleteNoteFirestore(Note note) async {
    final User? current_user = _auth.currentUser;
    await FirebaseFirestore.instance
        .collection("notes")
        .doc(current_user!.email.toString())
        .collection("usernotes")
        .doc(note.id.toString())
        .delete()
        .then((_) {
      print("DATA DELETED SUCCESS FULLY");
    });
  }
}
