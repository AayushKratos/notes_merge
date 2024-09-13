import 'package:notes/model/NoteModel.dart';
import 'package:notes/services/firestore_db.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NoteDatabase {
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
      ${NotesImpNames.archived} INTEGER
  
    )
    ''');
  }

  Future<int?> InsertEntry(Note note) async {
    await FireDB().createNewNoteFirestore(note);
    final db = await database;
    await db!.insert('Notes', note.toJson());
  }

  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;
    final orderBy = '${NotesImpNames.createdTime} ASC';
    final query_result =
        await db!.query(NotesImpNames.TableName, orderBy: orderBy);
    return query_result.map((json) => Note.fromJson(json)).toList();
  }

  Future<Note?> readOneNote(int id) async {
    final db = await instance.database;
    final map = await db!.query(NotesImpNames.TableName,
        columns: NotesImpNames.values,
        where: '${NotesImpNames.id} = ?',
        whereArgs: [id]);
    if (map.isNotEmpty) {
      return Note.fromJson(map.first);
    } else {
      return null;
    }
  }

  Future updateNote(Note note) async {
    await FireDB().updateNoteFirestore(note);
    final db = await instance.database;

    await db
        ?.update('Notes', note.toJson(), where: 'id = ?', whereArgs: [note.id]);
  }

  Future delteNote(Note note) async {
    await FireDB().deleteNoteFirestore(note);
    final db = await instance.database;

    await db!.delete(NotesImpNames.TableName,
        where: '${NotesImpNames.id}= ?', whereArgs: [note.id]);
  }

  Future<void> insertOrUpdate(Note note) async {
    final db = await database;
    await db!.insert(
      NotesImpNames.TableName,
      note.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Note>> getNotes({bool? pinned, bool? archived}) async {
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

  return List.generate(maps.length, (i) {
    return Note.fromJson(maps[i]);
  });
}

  Future closeDB() async {
    final db = await instance.database;
    db!.close();
  }
}
