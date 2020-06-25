import 'package:BoleirinhoApp/database/dao/ingrediente_dao.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> getDatabase() async{
  final String path = join(await getDatabasesPath(), 'boleirinho.db');

  return openDatabase(
    path,
    onCreate: (db, version) {
      db.execute(IngredienteDao.tableSql);
    },
    version: 1,
    onDowngrade: onDatabaseDowngradeDelete
  );
}