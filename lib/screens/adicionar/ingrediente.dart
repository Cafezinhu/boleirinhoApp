import 'package:BoleirinhoApp/models/editor.dart';
import 'package:BoleirinhoApp/models/ingrediente.dart';
import 'package:flutter/material.dart';

class AdicionarIngrediente extends StatefulWidget {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _unidadeController = TextEditingController();
  final TextEditingController _precoController = TextEditingController();
  @override
  _AdicionarIngredienteState createState() => _AdicionarIngredienteState();
}

class _AdicionarIngredienteState extends State<AdicionarIngrediente> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adicionar Ingrediente")
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          Editor(
            label: "Nome",
            controller: widget._nomeController
          ),
          Editor(
            label: "Unidade",
            hint: "g, mL, etc.",
            controller: widget._unidadeController,
          ),
          Editor(
            label: "Preço por unidade",
            hint: "0.00",
            icon: Icon(Icons.monetization_on),
            controller: widget._precoController,
            keyboardType: TextInputType.number,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 16.0),
            child: RaisedButton(
              child: Text("Salvar Ingrediente"),
              onPressed: () {
                _retornarDados(context);
              }
            ),
          )
        ],
        )
    );
  }

  void _retornarDados(BuildContext context){
    final String nome = widget._nomeController.text;
    final double preco = double.tryParse(widget._precoController.text);
    final String unidade = widget._unidadeController.text;
    if(nome != null && preco != null && unidade != null){
      Navigator.pop(context, Ingrediente(nome, preco, unidade));
    }
  }
}