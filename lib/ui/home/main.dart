import 'package:flutter/material.dart';
import 'package:notebook/data/database.dart';
import 'package:notebook/data/model.dart';
import 'package:notebook/data/note.dart';
import 'package:notebook/ui/add-note/main.dart';
import 'package:provider/provider.dart';

final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
        key: _scaffoldMessengerKey,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Notebook'),
          ),
          body: const _NoteList(),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _navigateToAddNotePage(context),
            tooltip: "Add note",
            child: const Icon(Icons.add),
          ),
        ));
  }

  void _navigateToAddNotePage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const AddNotePage(),
    ));
  }
}

class _NoteList extends StatelessWidget {
  const _NoteList();

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteModel>(builder: (context, model, child) {
      final notes = model.notes;
      if (notes == null) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (notes.isEmpty) {
        return Center(
          child: Text("No notes found",
              style: Theme.of(context).textTheme.bodyLarge),
        );
      }

      return ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) => _NoteListItem(note: notes[index]),
          padding: const EdgeInsets.symmetric(vertical: 16));
    });
  }
}

class _NoteListItem extends StatelessWidget {
  final Note note;

  const _NoteListItem({required this.note});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: ValueKey(note.id),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) => _deleteNote(context),
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        child: ListTile(
          title:
              Text(note.title, style: Theme.of(context).textTheme.titleMedium),
          subtitle: Text(note.content.firstLine,
              style: Theme.of(context).textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis),
        ));
  }

  Future<bool> _deleteNote(BuildContext context) async {
    try {
      final dao = await Dao.instance;
      await dao.deleteNote(id: note.id);
      return true;
    } catch (e) {
      debugPrint("Delete failed: $e");
      _scaffoldMessengerKey.currentState?.showSnackBar(
          const SnackBar(content: Text("Failed to delete note")));
      return false;
    }
  }
}

extension on String {
  String get firstLine {
    final i = indexOf("\n");
    if (i == -1) {
      return this;
    }
    return substring(0, i);
  }
}
