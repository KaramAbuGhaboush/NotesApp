import 'package:flutter/material.dart';
import 'package:notes_app/notes_sqdb.dart';
import 'package:notes_app/temp_data_provider.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: const Text("All notes",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
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
                  child: ListTile(
                    title: Text(note['title']?.toString() ?? 'No Title',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    subtitle: Text(
                        maxLines: null,
                        "Last edited on ${note['date']}",
                        overflow: TextOverflow.ellipsis,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.grey),
                      onPressed: () {
                        NotesSqflite.delete(note['id'] as int);
                        setState(() {});
                      },
                    ),
                    onTap: () {
                      Provider.of<TempDataProvider>(context, listen: false)
                          .setId(note['id'] as int);
                      setState(() {});
                      Navigator.pushNamed(context, '/update_note_page');
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
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.pushNamed(context, '/add_note_page');
        },
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
