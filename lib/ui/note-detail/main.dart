import 'package:flutter/material.dart';
import 'package:notebook/data/model.dart';
import 'package:notebook/data/note.dart';
import 'package:provider/provider.dart';

class NoteDetailPage extends StatelessWidget {
  final Note note;

  const NoteDetailPage({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note'),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: _NoteDetail(note: note)),
    );
  }
}

class _NoteDetail extends StatefulWidget {
  final Note note;

  const _NoteDetail({required this.note});

  @override
  _NoteDetailState createState() => _NoteDetailState();
}

class _NoteDetailState extends State<_NoteDetail> {
  final _titleController = TextEditingController();

  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.note.title;
    _contentController.text = widget.note.content;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopScope(
        onPopInvoked: (popped) => _saveNote(context),
        child: Column(
          children: [
            TextField(
              style: theme.textTheme.headlineSmall,
              decoration: const InputDecoration.collapsed(hintText: "Title"),
              controller: _titleController,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                maxLines: null,
                style: theme.textTheme.bodyLarge,
                decoration: const InputDecoration.collapsed(hintText: "Note"),
                controller: _contentController,
              ),
            )
          ],
        ));
  }

  Future<void> _saveNote(BuildContext context) async {
    try {
      final model = Provider.of<NoteModel>(context, listen: false);
      await model.updateNote(Note(
          id: widget.note.id,
          title: _titleController.text,
          content: _contentController.text,
          createdAt: widget.note.createdAt));
      await model.revalidateNotes();
    } catch (e) {
      debugPrint("Update failed: $e");
      // TODO: handle error
    }
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _contentController.dispose();
  }
}
