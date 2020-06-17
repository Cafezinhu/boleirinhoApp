import 'package:BoleirinhoApp/models/ingrediente.dart';
import 'package:flutter/material.dart';

class MostrarIngrediente extends StatefulWidget {
  final Ingrediente _ingrediente;
  MostrarIngrediente(this._ingrediente);
  @override
  _MostrarIngredienteState createState() => _MostrarIngredienteState();
}

class _MostrarIngredienteState extends State<MostrarIngrediente> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._ingrediente.nome)
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        child: Icon(Icons.edit)
      ),
      body: ListView.builder(
        itemCount: 2,
        itemBuilder: (context, index){
        if(index == 0){
          return Card(
            child: ListTile(
              title: Text("Unidade:"),
              subtitle: Text(widget._ingrediente.unidade),
              leading: Icon(Icons.local_cafe)
            ),
          );
        }
        return Card(
          child: ListTile(
            title: Text("Preço por unidade:"),
            subtitle: Text("R\$" + widget._ingrediente.precoPorUnidade.toString()),
            leading: Icon(Icons.monetization_on),
          ),
        );
      })
    );
  }
}