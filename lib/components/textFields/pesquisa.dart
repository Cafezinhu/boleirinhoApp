import 'package:flutter/material.dart';

class Pesquisa extends StatelessWidget {
  TextEditingController _controller;
  Function _onChanged;
  Pesquisa(this._controller, this._onChanged);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          labelStyle: TextStyle(
            fontSize: 24.0,
          ),
          labelText: "Pesquisar...",
          icon: Icon(Icons.search),
        ),
        onChanged: (value) {
          _onChanged();
        },
      ),
    );
  }
}
