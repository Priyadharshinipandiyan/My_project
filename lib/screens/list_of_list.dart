import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Undo/Redo Example')),
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> mainList = [];
  List<List<String>> undoStack = [];
  List<List<String>> redoStack = [];

  void addItem(String item) {
    setState(() {
      print("Main List:: ${mainList}");
      undoStack.add(List.from(mainList));
      mainList.add(item);
      redoStack.clear();
    });
  }

  void removeItem(String item) {
    setState(() {
      undoStack.add(List.from(mainList));
      mainList.remove(item);
      redoStack.clear();
    });
  }

  void undo() {
    if (undoStack.isNotEmpty) {
      setState(() {
        redoStack.add(List.from(mainList));
        mainList = undoStack.removeLast();
        print("Undo Main List:: ${mainList}");
      });
    }
    else{
      print("Undo List Is Empty");
    }
  }

  void redo() {
    if (redoStack.isNotEmpty) {
      setState(() {
        undoStack.add(List.from(mainList));
        mainList = redoStack.removeLast();
        print("Redo Main List:: ${mainList}");
      });
    }
    else{
      print("Redo List Is Empty");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          onSubmitted: (value) {
            addItem(value);
            print("Main List:: ${mainList}");
          },
          decoration: InputDecoration(labelText: 'Add item'),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: mainList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(mainList[index]),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    removeItem(mainList[index]);
                  },
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: undo,
              child: Text('Undo'),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: redo,
              child: Text('Redo'),
            ),
          ],
        ),
      ],
    );
  }
}
