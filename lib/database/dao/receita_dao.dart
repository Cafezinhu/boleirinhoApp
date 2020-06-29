import 'package:BoleirinhoApp/database/boleirinho_database.dart';
import 'package:BoleirinhoApp/database/dao/ingredienteNaReceita_dao.dart';
import 'package:BoleirinhoApp/models/ingrediente_na_receita.dart';
import 'package:BoleirinhoApp/models/receita.dart';
import 'package:sqflite/sqflite.dart';

class ReceitaDao {
  static const String tableSql = 'CREATE TABLE $_tableName('
      '$_id INTEGER PRIMARY KEY, '
      '$_nome TEXT, '
      '$_instrucoes TEXT, '
      '$_ingredientes TEXT, '
      '$_preco TEXT)';

  static const String _tableName = 'receitas';
  static const String _id = 'id';
  static const String _nome = 'nome';
  static const String _instrucoes = 'instrucoes';
  static const String _ingredientes = 'ingredientes';
  static const String _preco = 'preco';

  Future<int> save(Receita receita) async {
    final Database db = await getDatabase();

    final Map<String, dynamic> map = _toMap(receita);

    int id = await db.insert(_tableName, map);
    print("Receita salva com o id: " + id.toString());

    await IngredienteNaReceitaDao().save(receita.ingredientes, id);

    return id;
  }

  Map<String, dynamic> _toMap(Receita receita) {
    Map<String, dynamic> map = Map();
    map[_nome] = receita.nome;
    map[_instrucoes] = receita.instrucoes;
    map[_preco] = receita.preco.toString();

    return map;
  }

  Future<List<Receita>> findAll() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> mapList = await db.query(_tableName);

    List<Receita> receitas = await _toList(mapList);

    return receitas;
  }

  Future<List<Receita>> find(List<int> ids) async {
    Database db = await getDatabase();
    String sqlCondition = "";
    for (int id in ids) {
      sqlCondition += "$_id=${id.toString()} OR ";
    }
    if (sqlCondition.length > 0) {
      sqlCondition = sqlCondition.substring(0, sqlCondition.length - 4);
      print("sqlCondition: $sqlCondition");
      final List<Map<String, dynamic>> result =
          await db.rawQuery('SELECT * FROM $_tableName WHERE $sqlCondition');

      List<Receita> receitas = await _toList(result);
      return receitas;
    }
    return List();
  }

  Future<List<Receita>> _toList(List<Map<String, dynamic>> mapList) async {
    List<Receita> receitas = List();

    for (Map<String, dynamic> map in mapList) {
      final List<IngredienteNaReceita> ingredientes =
          await IngredienteNaReceitaDao().find(map[_id]);
      final Receita receita = Receita(map[_id], map[_nome], map[_instrucoes],
          double.parse(map[_preco]), ingredientes);

      receitas.add(receita);
    }

    return receitas;
  }
}
