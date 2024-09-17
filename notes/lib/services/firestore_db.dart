import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/model/NoteModel.dart';
import 'db.dart';

class FireDB with ChangeNotifier{
  //CREATE,READ,UPDATE,DELETE
  final FirebaseAuth _auth = FirebaseAuth.instance;

  createNewNoteFirestore(Note note) async {
    final User? current_user = _auth.currentUser;

    if (current_user != null) {
      await FirebaseFirestore.instance
          .collection("notes")
          .doc(current_user.email) 
          .collection("usernotes")
          .doc()
          .set({
        "Title": note.title,
        "content": note.content,
        "date": note.createdTime,
        "archived": false,
        "pin": false,
        "deleted": false,
      }).then((_) {
        print("DATA ADDED SUCCESSFULLY");
      });
    } else {
      print("Error: User is not logged in.");
    }
    notifyListeners();
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
            archived: false,
            fireId: note[""]
            )); 
      });
    });
    notifyListeners();
  }

  updateNoteFirestore(Note note, String fireId) async {
  final User? current_user = _auth.currentUser;
  await FirebaseFirestore.instance
      .collection("notes")
      .doc(current_user!.email)
      .collection("usernotes")
      .doc(fireId)
      .update({"title": note.title.toString(), "content": note.content});
  print("Data added Successfully");
  notifyListeners();
} 

  Future deleteNoteFirestore(String fireId) async {
  final User? currentUser = _auth.currentUser;

  if (currentUser == null) {
    print('Error: No authenticated user found.');
    return;
  }

  if (fireId.isEmpty) {
    print('Error: FireID is empty.');
    return;
  }

  try {
    await FirebaseFirestore.instance
        .collection("notes")
        .doc(currentUser.email.toString())
        .collection("usernotes")
        .doc(fireId)
        .delete();
    print("Data deleted successfully");
  } catch (error) {
    print("Failed to delete document: $error");
  }
  notifyListeners();
}

Future<void> fetchDocumentIds() async {
  CollectionReference collectionRef = FirebaseFirestore.instance.collection('yourCollection');

  QuerySnapshot querySnapshot = await collectionRef.get();

  querySnapshot.docs.forEach((doc) {
    print('Document ID: ${doc.id}');
  });
}

Future<String> fetchNoteByFireId(String fireId) async {
  try {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      print('No user is currently signed in.');
      return "";
    }
    
    DocumentReference documentRef = FirebaseFirestore.instance
        .collection("notes")
        .doc(currentUser.email)
        .collection("usernotes")
        .doc(fireId);
    
    DocumentSnapshot documentSnapshot = await documentRef.get();
    
    if (documentSnapshot.exists) {
      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
      print('Note Data: ${data['title']}, ${data['content']}');
      return fireId;
    } else {
      print('No document found with this fireId.');
      return "";
    }
  } catch (e) {
    print('Failed to fetch note: $e');
    return "";
  }
}



}