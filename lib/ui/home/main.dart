import 'package:flutter/material.dart';
import 'package:notebook/data/model.dart';
import 'package:notebook/data/note.dart';
import 'package:notebook/ui/add-note/main.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notebook'),
      ),
      body: const _NoteList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddNotePage(context),
        tooltip: "Add note",
        child: const Icon(Icons.add),
      ),
    );
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
    return ListTile(
      title: Text(note.title, style: Theme.of(context).textTheme.titleMedium),
      subtitle: Text(note.content.firstLine,
          style: Theme.of(context).textTheme.bodyMedium,
          overflow: TextOverflow.ellipsis),
    );
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
