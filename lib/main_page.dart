import 'package:flutter/material.dart'; // Import the Material widget
import 'package:notes_app/notes_sqdb.dart'; // Import the NotesSqflite class
import 'package:notes_app/temp_data_provider.dart'; // Import the NotesSqflite class
import 'package:provider/provider.dart'; // Import the Provider package

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
        automaticallyImplyLeading: false, // hides leading widget
        leading: null,
        title: const Text("All notes",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
      ),
      body: Center(
          child: FutureBuilder(
        // FutureBuilder widget is used to get the data from the database
        future: NotesSqflite.getNotes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // If the data is available then display the data in a ListView widget
            final notes = snapshot.data as List<Map<String, Object?>>;
            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Card(
                  child: ListTile(
                    // ListTile widget is used to display the data in a list
                    title: Text(
                        note['title']?.toString() ??
                            'No Title', // If the title is null then display 'No Title'
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    subtitle: Text(
                        maxLines: null,
                        "Last edited on ${note['date']}", // display the date
                        overflow: TextOverflow.ellipsis,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.grey),
                      onPressed: () {
                        // Delete the note from the database
                        NotesSqflite.delete(note['id'] as int);
                        setState(() {});
                      },
                    ),
                    onTap: () {
                      // Set the id of the note to be updated
                      Provider.of<TempDataProvider>(context, listen: false)
                          .setId(note['id'] as int);
                      setState(() {});
                      // Navigate to the UpdateNotePage
                      Navigator.pushNamed(context, '/update_note_page');
                    },
                  ),
                );
              },
            );
          } else {
            // If the data is not available then display a CircularProgressIndicator
            return const CircularProgressIndicator(
              color: Colors.yellow,
            );
          }
        },
      )),
      floatingActionButton: FloatingActionButton(
        // Floating action button to add a new note
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
