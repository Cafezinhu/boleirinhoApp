import 'package:BoleirinhoApp/database/boleirinho_database.dart';
import 'package:BoleirinhoApp/models/ingrediente_na_receita.dart';
import 'package:BoleirinhoApp/models/receita.dart';
import 'package:sqflite/sqflite.dart';

class ReceitaDao{
  static const String tableSql = 'CREATE TABLE $_tableName('
    '$_id INTEGER PRIMARY KEY'
    '$_nome TEXT, '
    '$_instrucoes TEXT, '
    '$_ingredientes TEXT, '
    '$_preco REAL)';

  static const String _tableName = 'receitas';
  static const String _id = 'id';
  static const String _nome = 'nome';
  static const String _instrucoes = 'instrucoes';
  static const String _ingredientes = 'ingredientes';
  static const String _preco = 'preco';

  Future<int> save(Receita receita) async{
    final Database db = await getDatabase();

    final Map<String, dynamic> map = _toMap(receita);

    return db.insert(_tableName, map);
  }

  Map<String, dynamic> _toMap(Receita receita){
    Map<String, dynamic> map = Map();
    map[_nome] = receita.nome;
    map[_instrucoes] = receita.instrucoes;
    //TODO: transformar os ingredientes usados em JSON
    map[_ingredientes] = "";
    map[_preco] = receita.preco;

    return map;
  }

  Future<List<Receita>> findAll() async{
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> mapList = await db.query(_tableName);

    List<Receita> receitas = _toList(mapList);

    return receitas;
  }

  List<Receita> _toList(List<Map<String, dynamic>> mapList){
    List<Receita> receitas = List();

    for(Map<String, dynamic> map in mapList){
      //TODO: conversão de JSON para lista de IngredientesNaReceita
      final List<IngredienteNaReceita> ingredientes = List();
      final Receita receita = Receita(map[_id], map[_nome], map[_instrucoes], map[_preco], ingredientes);

      receitas.add(receita);
    }

    return receitas;
  }

  String _ingredientesToJSON(List<IngredienteNaReceita> ingredientes){

  }

  List<IngredienteNaReceita> _jsonToIngredientes(String json){
    
  }
}