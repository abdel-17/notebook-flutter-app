import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:notebook/data/database.dart';
import 'package:notebook/data/note.dart';

class NoteModel extends ChangeNotifier {
  List<Note>? _notes;

  NoteModel() {
    // TODO: handle errors
    revalidateNotes();
  }

  Future<void> revalidateNotes() async {
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

  Future<void> insertNote(Note note) async {
    final dao = await Dao.instance;
    await dao.insertNote(note);
  }

  Future<void> updateNote(Note note) async {
    final dao = await Dao.instance;
    await dao.updateNote(note);
  }

  Future<void> deleteNote({required int id}) async {
    final dao = await Dao.instance;
    await dao.deleteNote(id: id);
  }
}
