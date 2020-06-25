import 'package:BoleirinhoApp/database/boleirinho_database.dart';
import 'package:BoleirinhoApp/models/ingrediente.dart';
import 'package:sqflite/sqflite.dart';

class IngredienteDao{
  //por alguma razão REAL não funciona
  static const String tableSql = 'CREATE TABLE $_tableName('
    '$_id INTEGER PRIMARY KEY, '
    '$_nome TEXT, '
    '$_precoPorUnidade TEXT, '
    '$_unidade TEXT)';

  
  static const String _tableName = 'ingredientes';
  static const String _id = 'id';
  static const String _nome = 'nome';
  static const String _precoPorUnidade = 'preco';
  static const String _unidade = 'unidade';

  Future<int> save(Ingrediente ingrediente) async{
    final Database db = await getDatabase();
    
    final Map<String, dynamic> map = _toMap(ingrediente);

    return db.insert(_tableName, map);
  }

  Map<String, dynamic> _toMap(Ingrediente ingrediente){
    final Map<String, dynamic> map = Map();
    map[_nome] = ingrediente.nome;
    map[_precoPorUnidade] = ingrediente.precoPorUnidade.toString();
    map[_unidade] = ingrediente.unidade;

    return map;
  }

  Future<List<Ingrediente>> findAll() async{
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(_tableName);

    List<Ingrediente> ingredientes = _toList(result);

    return ingredientes;
  }

  List<Ingrediente> _toList(List<Map<String, dynamic>> maplist){
    List<Ingrediente> ingredientes = List();

    for(Map<String, dynamic> map in maplist){
      ingredientes.add(Ingrediente(map[_id], map[_nome], double.parse(map[_precoPorUnidade]), map[_unidade]));
    }

    return ingredientes;
  }
}