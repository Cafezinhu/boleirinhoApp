import 'package:flutter/material.dart';

class CalculadoraHelp extends StatelessWidget {
  final BuildContext _ctx;
  CalculadoraHelp(this._ctx);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Text(
            "O que é a Calculadora de Preço?",
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          Text(
              "A Calculadora de Preço serve para calcular o custo por unidade do ingrediente, ou seja, o quanto que você gasta usando uma determinada porção do ingrediente."),
          Text(
              "Para calcular, é só colocar o preço do produto e a quantidade dele na calculadora."),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.pop(_ctx);
          },
          child: Text("Ok"),
        )
      ],
    );
    ;
  }
}
