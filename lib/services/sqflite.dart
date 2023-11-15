import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SqfLiteService {
  static Future get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future createFile(sql.Database database) async {
    await database.execute("""
      CREATE TABLE file(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        path TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
    """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'files.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createFile(database);
      },
    );
  }

  static Future<int> savedFile(File file) async {
    final path = await localPath;
    String savePath = '$path/${p.basename(file.path)}';
    File saveFile = File(savePath);
    await saveFile.writeAsBytes(await file.readAsBytes());
    final db = await SqfLiteService.db();
    final data = {
      'path': savePath,
    };
    final id = await db.insert(
      'file',
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
    return id;
  }

  static Future<List<Map<String, dynamic>>> getFolder() async {
    final db = await SqfLiteService.db();
    return db.query('file', orderBy: 'createdAt DESC');
  }

  static Future<List<Map<String, dynamic>>> getFile(int id) async {
    final db = await SqfLiteService.db();
    return db.query('file', where: 'id = ?', whereArgs: [id], limit: 1);
  }

  static Future removedFile(int id) async {
    final db = await SqfLiteService.db();
    try {
      await db.delete('file', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  static Future removedFiles() async {
    final db = await SqfLiteService.db();
    try {
      await db.delete('file');
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
}
