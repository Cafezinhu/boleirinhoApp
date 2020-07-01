import 'package:flutter/material.dart';

class TextoAdicionarIngredienteTelaReceita extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.7,
        alignment: Alignment.center,
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(style: TextStyle(color: Colors.black), children: [
            TextSpan(
                text:
                    "Você ainda não tem nenhum ingrediente registrado! Toque em "),
            WidgetSpan(
              child: Icon(Icons.local_cafe),
            ),
            TextSpan(
              text: " Ingredientes",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: " e depois em "),
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
