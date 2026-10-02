import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../domain/entity/profile_entity.dart';

/// Stores the signed-in user's profile for offline access between app launches.
class ProfileLocalDataSource {
  Database? _database;

  Future<void> saveProfile({
    required ProfileEntity profile,
    required String email,
  }) async {
    final database = await _getDatabase();
    await database.insert('profile', {
      'user_id': profile.userId,
      'username': profile.username,
      'display_name': profile.displayName,
      'email': email,
      'avatar_url': profile.avatarUrl,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Database> _getDatabase() async {
    if (_database != null) return _database!;
    final directory = await getDatabasesPath();
    _database = await openDatabase(
      join(directory, 'myspc.db'),
      version: 1,
      onCreate: (db, version) => db.execute('''
        CREATE TABLE profile (
          user_id TEXT PRIMARY KEY,
          username TEXT NOT NULL,
          display_name TEXT NOT NULL,
          email TEXT NOT NULL,
          avatar_url TEXT
        )
      '''),
    );
    return _database!;
  }
}
