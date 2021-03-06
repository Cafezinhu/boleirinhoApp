import 'package:BoleirinhoApp/models/ingrediente.dart';
import 'package:BoleirinhoApp/screens/mostrar/ingrediente.dart';
import 'package:flutter/material.dart';

class CartaoIngrediente extends StatelessWidget {
  final Ingrediente _ingrediente;
  CartaoIngrediente(this._ingrediente);
  @override
  Widget build(BuildContext context) {
    ScaffoldState scaffold = Scaffold.of(context);
    return Card(
      child: ListTile(
        title: Text(_ingrediente.nome),
        subtitle: Text("R\$" +
            _ingrediente.precoPorUnidade.toString() +
            " por " +
            _ingrediente.unidade),
        leading: Icon(Icons.local_cafe),
        onTap: () => {
          Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) => MostrarIngrediente(_ingrediente)))
              .then((value) {
            if (value != null) {
              scaffold.showSnackBar(SnackBar(
                backgroundColor: Colors.green,
                content: Text("Ingrediente excluído com sucesso!"),
              ));
            }
          })
        },
      ),
    );
  }
}
