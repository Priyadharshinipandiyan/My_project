import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sqflite Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Database? _database;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "demo.db");

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE Items (id INTEGER PRIMARY KEY, name TEXT)",
        );
      },
    );
  }

  Future<void> _createItem(String name) async {
    if (name.isNotEmpty) {
      await _database?.insert(
        'Items',
        {'name': name},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      _controller.clear();
      setState(() {});
    }
  }

  Future<List<Map<String, dynamic>>> _readItems() async {
    return await _database?.query('Items') ?? [];
  }

  Future<void> _updateItem(int id, String newName) async {
    await _database?.update(
      'Items',
      {'name': newName},
      where: 'id = ?',
      whereArgs: [id],
    );
    setState(() {});
  }

  Future<void> _deleteItem(int id) async {
    await _database?.delete(
      'Items',
      where: 'id = ?',
      whereArgs: [id],
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sqflite Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Enter item name'),
            ),
            ElevatedButton(
              onPressed: () {
                _createItem(_controller.text);
              },
              child: Text('Add Item'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewPage(database: _database)),
                );
              },
              child: Text('View Items'),
            ),
          ],
        ),
      ),
    );
  }
}

class ViewPage extends StatelessWidget {
  final Database? database;

  ViewPage({required this.database});

  Future<List<Map<String, dynamic>>> _readItems() async {
    return await database?.query('Items') ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Items'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _readItems(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          List<Map<String, dynamic>> items = snapshot.data!;

          return DataTable(
            columns: [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Actions')),
            ],
            rows: items.map((item) {
              return DataRow(
                cells: [
                  DataCell(Text(item['id'].toString())),
                  DataCell(Text(item['name'])),
                  DataCell(
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // You can add update functionality here
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            database?.delete(
                              'Items',
                              where: 'id = ?',
                              whereArgs: [item['id']],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
