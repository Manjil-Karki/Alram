import 'dart:io';

import 'package:alram/Database/models/brief_Alram_Model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static final _tableName = 'alramBrief';
  static final columnId = '_id';
  static final columnName = ['title', 'time', 'is_set', 'set_days'];

  DBProvider._();
  static final DBProvider instance = DBProvider._();

  static Database? _database;

  Future<Database> get database async => _database ??= await initDB();

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "alram.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE $_tableName (
            $columnId INTEGER PRIMARY KEY,
            ${columnName[0]} TEXT NOT NULL,
            ${columnName[1]} DATETIME NOT NULL,
            ${columnName[2]} BOOLEAN NOT NULL,
            ${columnName[3]} TEXT NOT NULL 
          )
          ''');
    });
  }

  Future<int> insert(BriefAlramModel model) async {
    Database db = await instance.database;
    return await db.insert(_tableName, model.toMap());
  }

  Future<List<BriefAlramModel>> querryAll() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);

    return List.generate(maps.length, (index) {
      return BriefAlramModel(
        id: maps[index][columnId],
        title: maps[index][columnName[0]],
        time: DateTime.fromMillisecondsSinceEpoch(maps[index][columnName[1]]),
        isSet: maps[index][columnName[2]],
        days: maps[index][columnName[3]],
      );
    });
  }

  Future<int> update(BriefAlramModel model) async {
    Database db = await instance.database;
    Map<String, dynamic> row = model.toMap();
    int id = row['_id'];
    return await db
        .update(_tableName, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<void> updateIsSet(int id, int isSet) async {
    Database db = await instance.database;

    return await db.execute('''
        UPDATE $_tableName
        SET ${columnName[2]} = $isSet
        WHERE  $columnId = $id
      ''');
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(_tableName, where: '$columnId = ?', whereArgs: [id]);
  }
}
