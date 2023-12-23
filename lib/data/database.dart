import 'package:notebook/data/note.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class _NotebookDatabase {
  static const _name = "notebook.db";
  static const _version = 1;

  static Future<Database> init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _name);
    return await openDatabase(path, version: _version, onCreate: _onCreate);
  }

  static _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${Note.tableName} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        content TEXT,
        created_at TEXT
      )
    ''');

    // TODO: remove sample data once "add note" functionality is added.
    final sampleData = [
      Note(
        id: 1,
        title: 'Note 1',
        content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
        createdAt: DateTime.now(),
      ),
      Note(
        id: 2,
        title: 'Note 2',
        content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
        createdAt: DateTime.now(),
      ),
    ];

    for (final sample in sampleData) {
      await db.insert(Note.tableName, sample.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }
}

class Dao {
  final Database _db;

  Dao._(this._db);

  // Maintain a single instance of the dao.
  static Dao? _instance;

  static Future<Dao> get instance async {
    final instance = _instance;
    if (instance != null) {
      return instance;
    }

    final db = await _NotebookDatabase.init();
    final dao = Dao._(db);
    _instance = dao;
    return dao;
  }

  Future<List<Note>> getNotes() async {
    final result = await _db.query(
      Note.tableName,
      columns: ['id', 'title', 'content', 'created_at'],
      orderBy: 'created_at DESC',
    );
    return result.map(Note.fromMap).toList();
  }

  Future<Note> getNote({required int id}) async {
    final result = await _db.query(
      Note.tableName,
      columns: ['id', 'title', 'content', 'created_at'],
      where: 'id = ?',
      whereArgs: [id],
    );
    return Note.fromMap(result.first);
  }

  Future<void> insertNote(Note note) async {
    await _db.insert(Note.tableName, note.toMap());
  }

  Future<void> updateNote(Note note) async {
    await _db.update(
      Note.tableName,
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }
}
