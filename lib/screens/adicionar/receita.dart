import 'package:flutter/material.dart';

class AdicionarReceita extends StatefulWidget {
  @override
  _AdicionarReceitaState createState() => _AdicionarReceitaState();
}

class _AdicionarReceitaState extends State<AdicionarReceita> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Receita')
      ),
    );
  }
}