import 'package:flutter/material.dart';
import 'package:notebook/data/database.dart';
import 'package:notebook/data/note.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notebook'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _NoteListWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: navigate to "add note" page
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _NoteListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getNotes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final notes = snapshot.data!;
            return ListView.builder(
                itemBuilder: (context, i) => _NoteWidget(note: notes[i]),
                itemCount: notes.length);
          }

          if (snapshot.hasError) {
            final error = snapshot.error!;
            debugPrint("Error: $error");
            // TODO: handle error
          }

          return const Center(child: CircularProgressIndicator());
        });
  }

  Future<List<Note>> _getNotes() async {
    final dao = await Dao.instance;
    return dao.getNotes();
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
