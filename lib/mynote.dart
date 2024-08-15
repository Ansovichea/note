import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:note/listnote.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'writenote.dart';

class Mynote extends StatefulWidget {
  @override
  State<Mynote> createState() => _MynoteState();
}

class _MynoteState extends State<Mynote> {
  List<Note> list = [];
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    List<String>? lines = sharedPreferences.getStringList("List");
    if (lines != null) {
      setState(() {
        list = lines.map((item) => Note.fromMap(json.decode(item))).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Notes"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Writenote(),
                ),
              );
              if (result == "loadData") {
                await getData(); // Refresh data
              }
            },
          ),
        ],
      ),
      body: list.isEmpty
          ? Center(child: Text("No notes available"))
          : ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Writenote(
                            note: list[index],
                            index: index,
                          ),
                        ),
                      ).then((result) {
                        if (result == "loadData") {
                          getData();
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 118, 228, 22),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 5, 5, 5)
                                .withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(list[index].title),
                        subtitle: Text(list[index].body),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              list.removeAt(index);
                              List<String> lines = list
                                  .map((item) => json.encode(item.toMap()))
                                  .toList();
                              sharedPreferences.setStringList("List", lines);
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
