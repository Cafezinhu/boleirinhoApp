import 'ingrediente.dart';

class IngredienteNaReceita{
  Ingrediente ingrediente;
  double quantidade;

  IngredienteNaReceita(this.ingrediente, this.quantidade);

  double calcularPreco(){
    return ingrediente.precoPorUnidade * quantidade;
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