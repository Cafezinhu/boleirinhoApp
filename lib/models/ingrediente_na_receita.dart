import 'package:BoleirinhoApp/utils/math.dart';

import 'ingrediente.dart';

class IngredienteNaReceita {
  Ingrediente ingrediente;
  double quantidade;
  int id;

  IngredienteNaReceita({this.id, this.ingrediente, this.quantidade});

  double calcularPreco() {
    if (ingrediente.precoPorUnidade == null || quantidade == null) return 0;
    return MathUtils.doubleRoundPrecision(
        ingrediente.precoPorUnidade * quantidade, 2);
  }

  String quantidadeExtensao() {
    if (ingrediente.unidade != "unidade")
      return quantidade.toString() + " " + ingrediente.unidade;

    return quantidade.toString();
  }

  String precoExtensao() {
    return "R\$" + calcularPreco().toString();
  }

  static IngredienteNaReceita clone(IngredienteNaReceita i) {
    IngredienteNaReceita novoIngrediente = IngredienteNaReceita(
        id: i.id, ingrediente: i.ingrediente, quantidade: i.quantidade);

    return novoIngrediente;
  }
}
