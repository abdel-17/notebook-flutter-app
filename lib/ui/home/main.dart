import 'package:flutter/material.dart';
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
        return const Center(
          child: Text("No notes found"),
        );
      }

      return ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) => _NoteListItem(note: notes[index]),
          padding: const EdgeInsets.all(16));
    });
  }
}

class _NoteListItem extends StatelessWidget {
  final Note note;

  const _NoteListItem({required this.note});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Dismissible(
                key: ValueKey(note.id),
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction) => _deleteNote(context),
                onDismissed: (direction) => _onNoteDeleted(context),
                background: Container(
                  alignment: Alignment.centerRight,
                  color: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: _NoteCard(note: note))));
  }

  Future<bool> _deleteNote(BuildContext context) async {
    try {
      final model = Provider.of<NoteModel>(context, listen: false);
      await model.deleteNote(id: note.id);
      return true;
    } catch (e) {
      debugPrint("Delete failed: $e");
      _scaffoldMessengerKey.currentState?.showSnackBar(
          const SnackBar(content: Text("Failed to delete note")));
      return false;
    }
  }

  Future<void> _onNoteDeleted(BuildContext context) async {
    // TODO: handle errors
    final model = Provider.of<NoteModel>(context, listen: false);
    await model.revalidateTodos();
  }
}

class _NoteCard extends StatelessWidget {
  final Note note;

  const _NoteCard({required this.note});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
        color: theme.colorScheme.surfaceVariant,
        child: ListTile(
          title: Text(note.title, style: theme.textTheme.titleMedium),
          subtitle: Text(note.content.firstLine,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant
              ),
              overflow: TextOverflow.ellipsis),
        ));
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
