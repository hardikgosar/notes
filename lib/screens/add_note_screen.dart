import 'package:flutter/material.dart';


import '../database/database_helper.dart';
import '../model/note_model.dart';
import './home_screen.dart';

class AddNoteScreen extends StatefulWidget {
  final Note? note;
  final Function? updateNoteList;

  const AddNoteScreen({Key? key, this.note, this.updateNoteList})
      : super(key: key);

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  late String _title;
  late String _body;
  late DateTime _date;
  late String _btnText;
  late String _titleText;

  // create the TextEditing Controller
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.note != null) {
      _title = widget.note!.title;
      titleController.text = _title;

      _body = widget.note!.body;
      bodyController.text = _body;
      _date = widget.note!.date;

      setState(() {
        _btnText = "Update Note";
        _titleText = "Update Note";
      });
    } else {
      setState(() {
        _btnText = "Save Note";
        _titleText = "Add Note";
      });
    }
  }

  _submit() {
    setState(() {
      _title = titleController.text;
      _body = bodyController.text;
      _date = DateTime.now();
    });
    Note note = Note(title: _title, body: _body, date: _date);
    if (widget.note == null) {
      DatabaseHelper.instance.insertNote(note);
      _toHomeScreen();
    } else {
      note.id = widget.note!.id;
      DatabaseHelper.instance.updateNote(note);
      _toHomeScreen();
    }
    widget.updateNoteList!();
  }

  _delete() {
    DatabaseHelper.instance.deleteNote(widget.note!);
    _toHomeScreen();
    widget.updateNoteList!;
  }

  _toHomeScreen() {
 
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titleText),
        actions: [
          widget.note != null
              ? IconButton(onPressed: _delete, icon: const Icon(Icons.delete))
              : const SizedBox.shrink()
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Note Title",
              ),
              style: const TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: TextField(
                controller: bodyController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Your note",
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _submit,
        label: Text(_btnText),
        icon: const Icon(Icons.save),
      ),
    );
  }
}
