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
      body: const _NoteListWidget(),
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

class _NoteListWidget extends StatelessWidget {
  const _NoteListWidget();

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
          itemBuilder: (context, index) => _NoteWidget(note: notes[index]));
    });
  }
}

class _NoteWidget extends StatelessWidget {
  final Note note;

  const _NoteWidget({required this.note});

  @override
  Widget build(BuildContext context) {
    // TODO: render something more interesting
    return ListTile(
      title: Text(note.title),
      subtitle: Text(note.content),
    );
  }
}
