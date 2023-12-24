import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:notebook/data/database.dart';
import 'package:notebook/data/note.dart';

class NoteModel extends ChangeNotifier {
  List<Note>? _notes;

  NoteModel() {
    fetchTodos();
  }

  Future<void> fetchTodos() async {
    // TODO: handle errors
    final dao = await Dao.instance;
    _fetchTodos(dao);
  }

  Future<void> _fetchTodos(Dao dao) async {
    _notes = await dao.getNotes();
    notifyListeners();
  }

  UnmodifiableListView<Note>? get notes {
    final notes = _notes;
    if (notes == null) {
      return null;
    }
    return UnmodifiableListView(notes);
  }

  Future<void> insertNote(Note note) async {
    final dao = await Dao.instance;
    await dao.insertNote(note);
    _fetchTodos(dao);
  }

  Future<void> updateNote(Note note) async {
    final dao = await Dao.instance;
    await dao.updateNote(note);
    _fetchTodos(dao);
  }

  Future<void> deleteNote({required int id}) async {
    final dao = await Dao.instance;
    await dao.deleteNote(id: id);
    _fetchTodos(dao);
  }
}
