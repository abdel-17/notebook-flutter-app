import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:notebook/data/database.dart';
import 'package:notebook/data/note.dart';

class NoteModel extends ChangeNotifier {
  List<Note>? _notes;

  NoteModel() {
    _init();
  }

  Future<void> _init() async {
    // TODO: handle errors
    final dao = await Dao.instance;
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

  Future<void> insert(Note note) async {
    final dao = await Dao.instance;
    await dao.insertNote(note);
    _notes = await dao.getNotes();
    notifyListeners();
  }

  Future<void> update(Note note) async {
    final dao = await Dao.instance;
    await dao.updateNote(note);
    _notes = await dao.getNotes();
    notifyListeners();
  }
}
