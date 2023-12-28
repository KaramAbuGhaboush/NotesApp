import 'package:flutter/material.dart';
import 'package:malak/notes_sqdb.dart';

class AddNoteDialog extends StatefulWidget {
  const AddNoteDialog({super.key});

  @override
  State<AddNoteDialog> createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends State<AddNoteDialog> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _subtitleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromARGB(255, 22, 18, 18),
      title: const Text('Add note', style: TextStyle(color: Colors.yellow)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            style: const TextStyle(color: Colors.white),
            controller: _titleController,
            decoration: const InputDecoration(
                border: InputBorder.none,
                labelText: 'Note title',
                labelStyle: TextStyle(color: Colors.yellow)),
          ),
          TextField(
            style: const TextStyle(color: Colors.white),
            controller: _subtitleController,
            decoration: const InputDecoration(
              labelText: 'Note',
              labelStyle: TextStyle(color: Colors.yellow),
              border: InputBorder.none,
            ),
            maxLines: null,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel', style: TextStyle(color: Colors.yellow)),
        ),
        TextButton(
          onPressed: () {
            NotesSqflite.insert({
              'title': _titleController.text,
              'subtitle': _subtitleController.text,
            });
            Navigator.of(context).pop();
          },
          child: const Text('Add', style: TextStyle(color: Colors.yellow)),
        ),
      ],
    );
  }
}
