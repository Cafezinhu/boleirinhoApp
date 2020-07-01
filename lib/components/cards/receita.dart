import 'package:BoleirinhoApp/models/ingrediente.dart';
import 'package:BoleirinhoApp/models/receita.dart';
import 'package:BoleirinhoApp/screens/mostrar/receita.dart';
import 'package:flutter/material.dart';

class CartaoReceita extends StatelessWidget {
  List<Ingrediente> _ingredientes;
  final Receita _receita;
  CartaoReceita(this._receita, this._ingredientes);
  @override
  Widget build(BuildContext context) {
    ScaffoldState scaffold = Scaffold.of(context);
    return Card(
      child: ListTile(
        title: Text(_receita.nome),
        subtitle: Text("R\$" + _receita.calcularPreco().toString()),
        leading: Icon(Icons.cake),
        onTap: () => {
          //chama a tela de receita
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (ctx) =>
                      MostrarReceita(_receita, _ingredientes))).then((value) {
            if (value != null) {
              scaffold.showSnackBar(SnackBar(
                backgroundColor: Colors.green,
                content: Text("Receita excluída com sucesso!"),
              ));
            }
          })
        },
      ),
    );
  }
}
