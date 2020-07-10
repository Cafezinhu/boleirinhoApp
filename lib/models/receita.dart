import 'package:BoleirinhoApp/utils/math.dart';

import 'ingrediente_na_receita.dart';

class Receita {
  int id;
  String nome, instrucoes;
  List<IngredienteNaReceita> ingredientes;
  double rendimentos;

  Receita(
      this.id, this.nome, this.instrucoes, this.ingredientes, this.rendimentos);

  double calcularCustoTotal() {
    double preco = 0;
    for (IngredienteNaReceita ingrediente in ingredientes) {
      preco += ingrediente.calcularPreco();
    }
    return MathUtils.doubleRoundPrecision(preco, 2);
  }

  double calcularPrecoDeRendimento() {
    double preco = calcularCustoTotal() / rendimentos;
    return MathUtils.doubleRoundPrecision(preco, 2);
  }

  static Receita clone(Receita receita) {
    List<IngredienteNaReceita> novosIngredientes = List();
    for (IngredienteNaReceita ingrediente in receita.ingredientes) {
      novosIngredientes.add(IngredienteNaReceita.clone(ingrediente));
    }

    Receita novaReceita = Receita(receita.id, receita.nome, receita.instrucoes,
        novosIngredientes, receita.rendimentos);
    return novaReceita;
  }
}
