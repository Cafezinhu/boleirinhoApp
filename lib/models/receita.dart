import 'ingrediente_na_receita.dart';

class Receita {
  int id;
  String nome, instrucoes;
  List<IngredienteNaReceita> ingredientes;

  Receita(this.id, this.nome, this.instrucoes, this.ingredientes);

  double calcularPreco() {
    double preco = 0;
    for (IngredienteNaReceita ingrediente in ingredientes) {
      preco += ingrediente.calcularPreco();
    }
    return preco;
  }

  static Receita clone(Receita receita) {
    List<IngredienteNaReceita> novosIngredientes = List();
    for (IngredienteNaReceita ingrediente in receita.ingredientes) {
      novosIngredientes.add(IngredienteNaReceita.clone(ingrediente));
    }

    Receita novaReceita = Receita(
        receita.id, receita.nome, receita.instrucoes, novosIngredientes);
    return novaReceita;
  }
}
