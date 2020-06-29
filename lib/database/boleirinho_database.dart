import 'package:BoleirinhoApp/database/dao/ingredienteNaReceita_dao.dart';
import 'package:BoleirinhoApp/database/dao/ingrediente_dao.dart';
import 'package:BoleirinhoApp/database/dao/receita_dao.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> getDatabase() async{
  final String path = join(await getDatabasesPath(), 'boleirinho.db');

  return openDatabase(
    path,
    onCreate: (db, version) {
      db.execute(IngredienteDao.tableSql);
      db.execute(ReceitaDao.tableSql);
      db.execute(IngredienteNaReceitaDao.tableSql);
    },
    version: 1,
    onDowngrade: onDatabaseDowngradeDelete
  );
}