import 'package:BoleirinhoApp/components/cards/ingrediente_na_receita.dart';
import 'package:BoleirinhoApp/models/receita.dart';
import 'package:flutter/material.dart';

class MostrarReceita extends StatefulWidget {
  final Receita _receita;
  MostrarReceita(this._receita);
  @override
  _MostrarReceitaState createState() => _MostrarReceitaState();
}

class _MostrarReceitaState extends State<MostrarReceita> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._receita.nome)
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        child: Icon(Icons.edit)
      ),
      body: ListView.builder(
        itemCount: widget._receita.ingredientes.length + 3,
        itemBuilder: (context, index){
          switch (index) {
            case 0:
              return Card(
                child: ListTile(
                  title: Text("Preço total: R\$" + widget._receita.preco.toString()),
                  leading: Icon(Icons.monetization_on),
                ),
              );
            case 1:
              return Card(
                child: ListTile(
                  title: Text("Instruções:"),
                  subtitle: Text(widget._receita.instrucoes),
                  leading: Icon(Icons.cake),
                ),
              );
              break;
            case 2:
              return Card(
                child: ListTile(
                  title: Text("Ingredientes: "),
                ),
              );
              break;
            default:
              return CartaoIngredienteNaReceita(widget._receita.ingredientes[index - 3]);
          }
        })
    );
  }
}