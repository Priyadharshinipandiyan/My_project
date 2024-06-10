import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_project/services/firestore.dart';

class Notes extends StatefulWidget {
  Notes({Key? key}) : super(key: key);

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<Notes> {

  final FireStore fireStore = FireStore();

  final TextEditingController textController = TextEditingController();

  void openNotesText(){
    showDialog(context: context, builder: (context) => AlertDialog(
      content: TextField(
        controller: textController,
      ),
      actions: [
        ElevatedButton(
            onPressed:() async {
              await fireStore.addNote(textController.text);
              textController.clear();
              Navigator.pop(context);
            },
            child: Text('Add')),
      ],
    ),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
                "Welcome"
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openNotesText,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}