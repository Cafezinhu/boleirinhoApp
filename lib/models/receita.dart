import 'ingrediente_na_receita.dart';

class Receita{
  String nome, instrucoes;
  double preco;
  List<IngredienteNaReceita> ingredientes;

  Receita(this.nome, this.instrucoes, this.preco, this.ingredientes);
}