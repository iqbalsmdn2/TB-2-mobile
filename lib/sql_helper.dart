import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
    CREATE TABLE student_db(
      id INTEGER PRIMARY KEY AUTO INCREMENT
      name TEXT NOT NULL,
      nim TEXT NOT NULL,
      phone TEXT,
      email TEXT
    )
    """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase("student_db.db", version: 1,
        onCreate:  (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  static Future<int> tambahStudent(String name, String nim, String phone, String email) async {
    final db = await SQLHelper.db();
    final data = {'name' : name, 'nim' : nim, 'phone' : phone, 'email' : email};
    return await db.insert('student_db', data);
  }

  static Future<List<Map<String, dynamic>>> getStudent() async {
    final db = await SQLHelper.db();
    return db.query('student_db');
  }

  static Future<int> ubahStudent(int id, String name, String nim, String phone, String email) async {
    final db = await SQLHelper.db();
    final data = {
      'name' : name,
      'nim' : nim,
      'phone' : phone,
      'email' : email
    };
    return await db.update('student_db', data, where: "id = $id");
  }

  static Future<int> hapusStudent(int id) async {
    final db = await SQLHelper.db();

    return await db.delete('student_db', where: "id = $id");
  }

  static Future<int> hapusSemuaStudent() async {
    final db = await SQLHelper.db() ;

    return await db.delete('student_db');
  }

}