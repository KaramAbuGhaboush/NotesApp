import 'package:flutter/material.dart';
import 'package:malak/add_note_dialog.dart';
import 'package:malak/notes_sqdb.dart';
import 'package:malak/temp_data_provider.dart';
import 'package:malak/update_note_dialog.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Color> tileColors = [
    const Color.fromARGB(255, 148, 255, 203),
    const Color.fromARGB(255, 173, 126, 255),
    const Color.fromARGB(255, 255, 175, 198),
    Color.fromARGB(255, 231, 254, 168),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const Text("notes", style: TextStyle(color: Colors.black)),
      ),
      body: Center(
          child: FutureBuilder(
        future: NotesSqflite.getNotes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final notes = snapshot.data as List<Map<String, Object?>>;
            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Card(
                  color: tileColors[index % tileColors.length],
                  child: ListTile(
                    title: Text(note['title']?.toString() ?? 'No Title'),
                    subtitle: Text(
                        maxLines: null,
                        note['subtitle']?.toString() ?? 'No Subtitle',
                        overflow: TextOverflow.ellipsis),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        NotesSqflite.delete(note['id'] as int);
                        setState(() {});
                      },
                    ),
                    onTap: () {
                      Provider.of<TempDataProvider>(context, listen: false)
                          .setId(note['id'] as int);
                      setState(() {});
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const UpdateNoteDialog();
                        },
                      ).then((value) => setState(() {}));
                    },
                  ),
                );
              },
            );
          } else {
            return const CircularProgressIndicator(
              color: Colors.yellow,
            );
          }
        },
      )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return const AddNoteDialog();
            },
          ).then((value) => setState(() {}));
        },
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
