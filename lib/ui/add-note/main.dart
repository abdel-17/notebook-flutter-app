import 'package:flutter/material.dart';
import 'package:notebook/data/model.dart';
import 'package:notebook/data/note.dart';
import 'package:provider/provider.dart';

final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class AddNotePage extends StatelessWidget {
  const AddNotePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
        key: _scaffoldMessengerKey,
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Add Note'),
            ),
            body: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: _NoteForm())));
  }
}

class _NoteForm extends StatefulWidget {
  const _NoteForm();

  @override
  _NoteFormState createState() => _NoteFormState();
}

class _NoteFormState extends State<_NoteForm> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();

  final _noteController = TextEditingController();

  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              autofocus: true,
              decoration: const InputDecoration.collapsed(hintText: "Title"),
              style: Theme.of(context).textTheme.titleLarge,
              validator: _titleValidator,
              controller: _titleController,
            ),
            const SizedBox(height: 20),
            TextFormField(
                maxLines: null,
                decoration: const InputDecoration.collapsed(hintText: "Note"),
                style: Theme.of(context).textTheme.bodyLarge,
                validator: _noteValidator,
                controller: _noteController),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _onSave,
              child: const Text("Save"),
            )
          ],
        ));
  }

  String? _titleValidator(String? title) {
    if (title == null || title.isEmpty) {
      return "Please enter the title";
    }
    return null;
  }

  String? _noteValidator(String? note) {
    if (note == null || note.isEmpty) {
      return "Please enter the note";
    }
    return null;
  }

  void _onSave() async {
    if (_saving) {
      // Prevent multiple saves.
      return;
    }

    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    try {
      _saving = true;

      final model = Provider.of<NoteModel>(context, listen: false);
      final note = Note(
          title: _titleController.value.text,
          content: _noteController.value.text,
          createdAt: DateTime.now());
      await model.insertNote(note);
      await model.revalidateTodos();

      // Navigate back if the widget is still mounted.
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      debugPrint("Save failed: $e");
      _scaffoldMessengerKey.currentState
          ?.showSnackBar(const SnackBar(content: Text("Failed to save note")));
    } finally {
      _saving = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _noteController.dispose();
  }
}
