import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../model/note_model.dart';
import './add_note_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Note>> _notelist;
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  _updateNoteList() {
    _notelist = _databaseHelper.getNoteList();
  }

  @override
  void initState() {
    super.initState();
    _updateNoteList();
  }

  Widget _buildNote(Note note) {
    return Card(
      child: ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddNoteScreen(
                    updateNoteList: _updateNoteList(),
                    note: note,
                  ),
                ));
          },
          title: Text(note.title),
          subtitle: Text(note.body),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              setState(() {
                _databaseHelper.deleteNote(note);
                _updateNoteList();
              });
            },
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Notes',
        style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
      )),
      body: FutureBuilder(
          future: _notelist,
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                  child: Text(
                "You don't have any notes yet , create one",
                style: TextStyle(fontSize: 20.0),
              ));
            }

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: int.parse(snapshot.data!.length.toString()),
                itemBuilder: (BuildContext context, int index) {
                  return _buildNote(snapshot.data![index]);
                },
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AddNoteScreen(),
              ));
        },
        tooltip: 'Add Note',
        child: const Icon(Icons.add),
      ),
    );
  }
}
