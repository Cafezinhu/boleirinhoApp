import 'package:flutter/material.dart';

class TextoAdicionarIngrediente extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.7,
        alignment: Alignment.center,
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(style: TextStyle(color: Colors.black), children: [
            TextSpan(text: "Toque em "),
            WidgetSpan(
              child: Icon(Icons.add_circle),
            ),
            TextSpan(text: " para adicionar um novo ingrediente."),
          ]),
        ),
      ),
    );
  }
}
