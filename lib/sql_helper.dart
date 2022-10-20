import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
    CREATE TABLE note(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      nama TEXT,
      pelanggaran TEXT
    )
""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase('note.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  //tambah data
  static Future<int> tambahNote(String nama, String pelanggaran) async {
    final db = await SQLHelper.db();
    final data = {'nama': nama, 'pelanggaran': pelanggaran};
    return await db.insert('note', data);
  }

  //ambil data
  static Future<List<Map<String, dynamic>>> getNote() async {
    final db = await SQLHelper.db();
    return db.query('note');
  }

  //fumgsi ubah
  static Future<int> ubahNote(int id, String nama, String pelanggaran) async {
    final db = await SQLHelper.db();

    final data = {'nama': nama, 'pelanggaran': pelanggaran};

    return await db.update('note', data, where: "id = $id");
  }

  //fungsi hapus
  static Future<void> hapusNote(int id) async {
    final db = await SQLHelper.db();
    await db.delete('note', where: "id = $id");
  }
}
