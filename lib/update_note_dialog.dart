import 'package:flutter/material.dart';
import 'package:malak/notes_sqdb.dart';
import 'package:malak/temp_data_provider.dart';
import 'package:provider/provider.dart';

class UpdateNoteDialog extends StatefulWidget {
  const UpdateNoteDialog({super.key});

  @override
  State<UpdateNoteDialog> createState() => _UpdateNoteDialogState();
}

class _UpdateNoteDialogState extends State<UpdateNoteDialog> {
  Future<String> getNoteTitle() async {
    List<Map<String, Object?>> note = await NotesSqflite.getNote(
        Provider.of<TempDataProvider>(context, listen: false).getId());
    return note[0]['title']?.toString() ?? 'No Title';
  }

  Future<String> getNoteSubtitle() async {
    List<Map<String, Object?>> note = await NotesSqflite.getNote(
        Provider.of<TempDataProvider>(context, listen: false).getId());
    return note[0]['subtitle']?.toString() ?? 'No Subtitle';
  }

  TextEditingController _titleController = TextEditingController();
  TextEditingController _subtitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update note'),
      content: FutureBuilder(
        future: getNoteTitle(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _titleController.text = snapshot.data as String;
            return FutureBuilder(
              future: getNoteSubtitle(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _subtitleController.text = snapshot.data as String;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Note title',
                        ),
                      ),
                      TextField(
                        controller: _subtitleController,
                        decoration: const InputDecoration(
                          labelText: 'Note',
                        ),
                        maxLines: null,
                      ),
                    ],
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            NotesSqflite.update({
              'id':
                  Provider.of<TempDataProvider>(context, listen: false).getId(),
              'title': _titleController.text,
              'subtitle': _subtitleController.text,
            });
            Navigator.of(context).pop();
          },
          child: const Text('Update'),
        ),
      ],
    );
  }
}
