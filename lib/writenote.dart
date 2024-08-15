import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:note/listnote.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Writenote extends StatefulWidget {
  final Note? note;
  final int? index;

  const Writenote({
    super.key,
    this.note,
    this.index,
  });

  @override
  State<Writenote> createState() => _WritenoteState();
}

class _WritenoteState extends State<Writenote> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController bodyController;

  List<Note> list = [];
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    bodyController = TextEditingController();
    getData();

    if (widget.note != null) {
      titleController.text = widget.note!.title;
      bodyController.text = widget.note!.body;
    }
  }

  Future<void> getData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    List<String>? lines = sharedPreferences.getStringList("List");
    if (lines != null) {
      list = lines.map((item) => Note.fromMap(json.decode(item))).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(widget.index == null ? "Write Note" : "Edit Note"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                if (widget.index == null) {
                  // Add new note
                  list.add(Note(
                    title: titleController.text,
                    body: bodyController.text,
                  ));
                } else {
                  // Update existing note
                  list[widget.index!] = Note(
                    title: titleController.text,
                    body: bodyController.text,
                  );
                }
                List<String> lines =
                    list.map((item) => json.encode(item.toMap())).toList();
                sharedPreferences.setStringList("List", lines);
                Navigator.pop(context,
                    "loadData"); // Notify that data should be refreshed
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: bodyController,
                maxLines: 10,
                decoration: InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter content';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (widget.index == null) {
                      // Add new note
                      list.add(Note(
                        title: titleController.text,
                        body: bodyController.text,
                      ));
                    } else {
                      // Update existing note
                      list[widget.index!] = Note(
                        title: titleController.text,
                        body: bodyController.text,
                      );
                    }
                    List<String> lines =
                        list.map((item) => json.encode(item.toMap())).toList();
                    sharedPreferences.setStringList("List", lines);
                    Navigator.pop(context,
                        "loadData"); // Notify that data should be refreshed
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.save),
                    SizedBox(width: 8),
                    Text("Save Note"),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
