import 'package:passport_gen/model/passport.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sql.dart';

class SqlHelper {
  static Future<void> createTable(sql.Database database) async {
    await database.execute(
      """
      CREATE TABLE passports(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        image TEXT NOT NULL,
        full_name TEXT NOT NULL,
        address TEXT NOT NULL,
        city TEXT NOT NULL,
        passport_got TEXT NOT NULL,
        passport_expire TEXT NOT NULL
      )
      """
    );
    await database.execute(
        """
      CREATE TABLE favorites(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        image TEXT NOT NULL,
        full_name TEXT NOT NULL,
        address TEXT NOT NULL,
        city TEXT NOT NULL,
        passport_got TEXT NOT NULL,
        passport_expire TEXT NOT NULL
      )
      """
    );
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'passport.db,',
      version: 2,
      onCreate: (sql.Database database, int version) async {
       await createTable(database);
      }
    );
  }

  static Future<void> saveFavoritePassport(Passport passport) async {
    final db = await SqlHelper.db();
    db.insert('favorites', passport.toJson());
  }

  static Future<List<Passport>> getAllFavorites() async {
    final db = await SqlHelper.db();
    final data = await db.query('favorites',orderBy: 'id');
    final List<Passport> passports = [];

    for(var i in data) {
      final passport = Passport.fromJson(i);
      passports.add(passport);
    }
    return passports;
  }

  static Future<void> saveNewPassport(Passport passport) async {
    final db = await SqlHelper.db();
    db.insert('passports', passport.toJson());
  }
  static Future<List<Passport>> getAllPassports() async {
    final db = await SqlHelper.db();
    final data = await db.query('passports',orderBy: 'id');
    final List<Passport> passports = [];

    for(var i in data) {
      final passport = Passport.fromJson(i);
      passports.add(passport);
    }
    return passports;
  }
  static Future<void> deletePassport(int? id) async {
    final db = await SqlHelper.db();
    await db.delete('passports', where: 'id = ?', whereArgs: [id]);
  }
  static Future<void> updatePassport(int? id, Passport passport) async {
    final db = await SqlHelper.db();
    final data = await db.update('passports', passport.toJson(), where: 'id = ?', whereArgs: [id]);
    print(data);
  }
}