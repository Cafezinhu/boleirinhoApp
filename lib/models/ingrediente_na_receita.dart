import 'package:BoleirinhoApp/utils/math.dart';

import 'ingrediente.dart';

class IngredienteNaReceita{
  Ingrediente ingrediente;
  double quantidade;

  IngredienteNaReceita(this.ingrediente, this.quantidade);

  double calcularPreco(){
    return MathUtils.doubleRoundPrecision(ingrediente.precoPorUnidade * quantidade, 2);
  }

  String quantidadeExtensao(){
    if(ingrediente.unidade != "unidade")
      return quantidade.toString() + " " + ingrediente.unidade;
    
    return quantidade.toString();
  }

  String precoExtensao(){
    return "R\$" + calcularPreco().toString();
  }
}