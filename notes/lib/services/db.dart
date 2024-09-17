import 'package:flutter/material.dart';
import 'package:notes/model/NoteModel.dart';
import 'package:notes/services/firestore_db.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NoteDatabase with ChangeNotifier {
  static final NoteDatabase instance = NoteDatabase._init();
  static Database? _database;
  NoteDatabase._init();

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initializeDB('Notes.db');
    return _database;
  }

  Future<Database> _initializeDB(String filepath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filepath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final boolType = ' BOOLEAN NOT NULL';
    final textType = 'TEXT NOT NULL';
    await db.execute('''
    CREATE TABLE Notes(
      ${NotesImpNames.id} $idType,
      ${NotesImpNames.pin} $boolType,
      ${NotesImpNames.title} $textType,
      ${NotesImpNames.content} $textType,
      ${NotesImpNames.createdTime} $textType,
      ${NotesImpNames.archived} INTEGER,
      ${NotesImpNames.fireID} $textType
    )
    ''');
  }

  Future<Note> InsertEntry(Note note) async {
    final db = await database;
    await FireDB().createNewNoteFirestore(note);
    final id = await db!.insert(NotesImpNames.TableName, note.toJson());
    notifyListeners();
    return note.copy(id: id);
  }

  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;
    final orderBy = '${NotesImpNames.createdTime} ASC';
    final query_result =
        await db!.query(NotesImpNames.TableName, orderBy: orderBy);
    notifyListeners();
    return query_result.map((json) => Note.fromJson(json)).toList();
  }

  Future<Note?> readOneNote(int id) async {
    final db = await instance.database;
    final map = await db!.query(NotesImpNames.TableName,
        columns: NotesImpNames.values,
        where: '${NotesImpNames.id} = ?',
        whereArgs: [id]);
    notifyListeners();
    if (map.isNotEmpty) {
      return Note.fromJson(map.first);
    } else {
      return null;
    }
  }

  Future updateNote(Note note) async {
    final db = await instance.database;
    final result = await db!.query('Notes',
        columns: ['fireId'], where: 'id = ?', whereArgs: [note.id]);

    if (result.isNotEmpty) {
      final fireID = FireDB().fetchNoteByFireId(note.fireId);
      // final fireId = result.first['fireId'] as String?;
      await db.update(
        'Notes',
        note.toJson(),
        where: 'id = ?',
        whereArgs: [note.id],
      );

      notifyListeners();
      if (fireID == false) {
        await FireDB().updateNoteFirestore(note, fireID as String);
      } else {
        print('FireId is null or not a string.');
      }
    } else {
      print('Note not found in the local database.');
    }
  }

  Future delteNote(Note note) async {
    final db = await instance.database;

    final result = await db!.query(
      'Notes',
      columns: ['fireId'],
      where: 'id = ?',
      whereArgs: [note.id],
    );

    if (result.isNotEmpty) {
      final fireId = result.first['fireId'] as String?;

      await db.delete(NotesImpNames.TableName,
          where: '${NotesImpNames.id} = ?', whereArgs: [note.id]);
      notifyListeners();
      if (fireId != null) {
        await FireDB().deleteNoteFirestore(fireId);
      } else {
        print('FireID is null');
      }
    } else {
      print('Note not found');
    }
  }

  Future<void> insertOrUpdate(Note note) async {
    final db = await database;
    await db!.insert(
      NotesImpNames.TableName,
      note.toJson(),
    );
    notifyListeners();
  }

  Future<List<Note>> getNotes({
    bool? pinned,
    bool? archived,
  }) async {
    // await FireDB().updateNoteFirestore(note);
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(
      NotesImpNames.TableName,
      where: (pinned != null ? '${NotesImpNames.pin} = ? AND ' : '') +
          (archived != null ? '${NotesImpNames.archived} = ?' : ''),
      whereArgs: [
        if (pinned != null) (pinned ? 1 : 0),
        if (archived != null) (archived ? 1 : 0)
      ].whereType<int>().toList(),
    );
    notifyListeners();
    return List.generate(maps.length, (i) {
      return Note.fromJson(maps[i]);
    });
  }

  Future closeDB() async {
    final db = await instance.database;
    db!.close();
    notifyListeners();
  }
}
