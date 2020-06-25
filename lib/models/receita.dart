import 'ingrediente_na_receita.dart';

class Receita{
  int id;
  String nome, instrucoes;
  double preco;
  List<IngredienteNaReceita> ingredientes;

  Receita(this.id, this.nome, this.instrucoes, this.preco, this.ingredientes);
}