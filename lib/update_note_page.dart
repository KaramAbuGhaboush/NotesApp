import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes_app/notes_sqdb.dart';
import 'package:notes_app/temp_data_provider.dart';
import 'package:provider/provider.dart';

class UpdateNotePage extends StatefulWidget {
  const UpdateNotePage({super.key});

  @override
  State<UpdateNotePage> createState() => _UpdateNotePageState();
}

class _UpdateNotePageState extends State<UpdateNotePage> {
  Future getNoteContent() async {
    final note = await NotesSqflite.getNote(
        Provider.of<TempDataProvider>(context, listen: false).getId());
    _titleController.text = note[0]['title'].toString();
    return jsonDecode(note[0]['content'].toString());
  }

  QuillController _controller = QuillController.basic();
  final TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Note',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        ),
        body: FutureBuilder(
          future: getNoteContent(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _controller = QuillController(
                  document: Document.fromJson(snapshot.data as List<dynamic>),
                  selection: const TextSelection.collapsed(offset: 0));
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10),
                    child: TextField(
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 30),
                      controller: _titleController,
                      decoration: const InputDecoration(
                        hintText: 'Title',
                        border: null,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: QuillToolbar.simple(
                      configurations: QuillSimpleToolbarConfigurations(
                        controller: _controller,
                        sharedConfigurations: const QuillSharedConfigurations(
                          locale: Locale('ar'),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 30.0, right: 30.0),
                      child: QuillEditor.basic(
                        configurations: QuillEditorConfigurations(
                          controller: _controller,
                          readOnly: false,
                          sharedConfigurations: const QuillSharedConfigurations(
                            locale: Locale('ar'),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_titleController.text.isEmpty &&
                _controller.document.isEmpty()) {
              Navigator.pushReplacementNamed(context, '/main_page');
            } else if (_titleController.text.isEmpty) {
              _titleController.text = 'Untitled Note';
              NotesSqflite.update(
                  Provider.of<TempDataProvider>(context, listen: false).getId(),
                  _titleController.text,
                  jsonEncode(_controller.document.toDelta().toJson()),
                  DateTime.now().toString());
              Navigator.pushReplacementNamed(context, '/main_page');
            } else {
              NotesSqflite.update(
                  Provider.of<TempDataProvider>(context, listen: false).getId(),
                  _titleController.text,
                  jsonEncode(_controller.document.toDelta().toJson()),
                  DateTime.now().toString());
              Navigator.pushReplacementNamed(context, '/main_page');
            }
          },
          backgroundColor: Colors.yellow,
          child: const Icon(Icons.save, color: Colors.black),
          shape: const CircleBorder(),
        ));
  }
}
