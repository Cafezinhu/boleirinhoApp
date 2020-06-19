import 'package:BoleirinhoApp/models/ingrediente_na_receita.dart';
import 'package:flutter/material.dart';

class CartaoIngredienteNaReceita extends StatelessWidget {
  final IngredienteNaReceita _ingredienteNaReceita;
  CartaoIngredienteNaReceita(this._ingredienteNaReceita);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(_ingredienteNaReceita.ingrediente.nome),
        subtitle: Text(
          _ingredienteNaReceita.quantidade.toString() + " " + _ingredienteNaReceita.ingrediente.unidade
          + "\nR\$" + (_ingredienteNaReceita.calcularPreco()).toString()
        ),
        leading: Icon(Icons.local_cafe),
      ),
    );
  }
}