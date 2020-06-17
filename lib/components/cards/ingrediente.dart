import 'package:BoleirinhoApp/models/ingrediente.dart';
import 'package:flutter/material.dart';

class CartaoIngrediente extends StatelessWidget {
  final Ingrediente _ingrediente;
  CartaoIngrediente(this._ingrediente);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(_ingrediente.nome),
        subtitle: Text("R\$" + _ingrediente.precoPorUnidade.toString() + " por " + _ingrediente.unidade),
        leading: Icon(Icons.local_cafe),
        onTap: () => {
          //chama a tela de ingrediente
        },
      ),
    );
  }
}