import 'package:flutter/material.dart';

class AdicionarIngrediente extends StatefulWidget {
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
    );
  }
}