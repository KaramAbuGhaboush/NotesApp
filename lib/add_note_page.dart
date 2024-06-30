import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes_app/notes_sqdb.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final QuillController _controller = QuillController.basic();
  final TextEditingController _titleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Note',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10),
            child: TextField(
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Title',
                hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                border: null,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: QuillToolbar.simple(
              configurations: QuillSimpleToolbarConfigurations(
                controller: _controller,
                sharedConfigurations: const QuillSharedConfigurations(
                  locale: Locale('en'),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 10.0, left: 30.0, right: 30.0),
              child: QuillEditor.basic(
                configurations: QuillEditorConfigurations(
                  controller: _controller,
                  sharedConfigurations: const QuillSharedConfigurations(
                    locale: Locale('en'),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_titleController.text.isEmpty && _controller.document.isEmpty()) {
            Navigator.pushReplacementNamed(context, '/main_page');
          } else if (_titleController.text.isEmpty) {
            _titleController.text = 'Untitled Note';
            NotesSqflite.insert(
                _titleController.text,
                jsonEncode(_controller.document.toDelta().toJson()),
                DateTime.now().toString());
            Navigator.pushReplacementNamed(context, '/main_page');
          } else {
            NotesSqflite.insert(
                _titleController.text,
                jsonEncode(_controller.document.toDelta().toJson()),
                DateTime.now().toString());
            Navigator.pushReplacementNamed(context, '/main_page');
          }
        },
        backgroundColor: Colors.yellow,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.save,
          color: Colors.black,
        ),
      ),
    );
  }
}
