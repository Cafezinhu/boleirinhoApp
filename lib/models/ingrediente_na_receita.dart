import 'ingrediente.dart';

class IngredienteNaReceita{
  Ingrediente ingrediente;
  double quantidade;

  IngredienteNaReceita(this.ingrediente, this.quantidade);

  double calcularPreco(){
    return ingrediente.precoPorUnidade * quantidade;
  }
}