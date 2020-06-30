import 'package:BoleirinhoApp/database/boleirinho_database.dart';
import 'package:BoleirinhoApp/database/dao/ingrediente_dao.dart';
import 'package:BoleirinhoApp/database/dao/receita_dao.dart';
import 'package:BoleirinhoApp/models/ingrediente.dart';
import 'package:BoleirinhoApp/models/ingrediente_na_receita.dart';
import 'package:BoleirinhoApp/models/receita.dart';
import 'package:sqflite/sqflite.dart';

class IngredienteNaReceitaDao {
  static const String tableSql = 'CREATE TABLE $_tableName('
      '$_id INTEGER PRIMARY KEY, '
      '$_receitaId INTEGER, '
      '$_ingredienteId INTEGER, '
      '$_quantidade TEXT)';

  static const String _tableName = 'ingredientes_na_receita';
  static const String _id = 'id';
  static const String _receitaId = 'receita_id';
  static const String _ingredienteId = 'ingrediente_id';
  static const String _quantidade = 'quantidade';

  Future<List<IngredienteNaReceita>> find(int receitaId) async {
    Database db = await getDatabase();
    List<Map<String, dynamic>> result = await db
        .rawQuery('SELECT * FROM $_tableName WHERE $_receitaId=?', [receitaId]);

    List<IngredienteNaReceita> ingredientesNaReceita = await _toList(result);

    return ingredientesNaReceita;
  }

  Future<List<Receita>> findReceitasByIngredienteId(int id) async {
    Database db = await getDatabase();
    List<Map<String, dynamic>> result = await db
        .rawQuery('SELECT * FROM $_tableName WHERE $_ingredienteId=?', [id]);
    List<int> ids = List();
    for (Map<String, dynamic> map in result) {
      ids.add(map[_receitaId]);
    }
    List<Receita> receitas = await ReceitaDao().find(ids);

    return receitas;
  }

  Future<List<IngredienteNaReceita>> _toList(
      List<Map<String, dynamic>> mapList) async {
    List<IngredienteNaReceita> list = List();
    for (Map<String, dynamic> map in mapList) {
      List<Ingrediente> ingredientes =
          await IngredienteDao().findById([map[_ingredienteId]]);
      Ingrediente ingrediente = ingredientes[0];
      list.add(
          IngredienteNaReceita(ingrediente, double.parse(map[_quantidade])));
    }

    return list;
  }

  Future<List<int>> save(
      List<IngredienteNaReceita> ingredientesNaReceita, int receitaId) async {
    Database db = await getDatabase();
    List<Map<String, dynamic>> mapList =
        _toMapList(ingredientesNaReceita, receitaId);
    List<int> ids = List();
    for (Map<String, dynamic> map in mapList) {
      int id = await db.insert(_tableName, map);
      ids.add(id);
    }
    return ids;
  }

  List<Map<String, dynamic>> _toMapList(
      List<IngredienteNaReceita> list, int receitaId) {
    List<Map<String, dynamic>> mapList = List();

    for (IngredienteNaReceita ingredienteNaReceita in list) {
      Map<String, dynamic> map = Map();
      map[_receitaId] = receitaId;
      map[_ingredienteId] = ingredienteNaReceita.ingrediente.id;
      map[_quantidade] = ingredienteNaReceita.quantidade.toString();
      mapList.add(map);
    }

    return mapList;
  }

  Future<int> delete(int id) async {
    Database db = await getDatabase();

    return await db
        .rawDelete('DELETE FROM $_tableName WHERE $_receitaId=?', [id]);
  }
}
