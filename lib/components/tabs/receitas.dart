import 'package:BoleirinhoApp/components/cards/receita.dart';
import 'package:BoleirinhoApp/components/richtext/add_ingrediente_tela_receita.dart';
import 'package:BoleirinhoApp/components/richtext/add_receita.dart';
import 'package:BoleirinhoApp/database/dao/ingrediente_dao.dart';
import 'package:BoleirinhoApp/database/dao/receita_dao.dart';
import 'package:BoleirinhoApp/models/enums/modo.dart';
import 'package:BoleirinhoApp/models/ingrediente.dart';
import 'package:BoleirinhoApp/models/receita.dart';
import 'package:BoleirinhoApp/screens/form/receita.dart';
import 'package:flutter/material.dart';

class ReceitasTab extends StatefulWidget {
  IngredienteDao _ingredienteDao;
  ReceitaDao _receitaDao;
  List<Ingrediente> _ingredientes;
  ReceitasTab(this._ingredienteDao, this._receitaDao);

  @override
  _ReceitasTabState createState() => _ReceitasTabState();
}

class _ReceitasTabState extends State<ReceitasTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: widget._receitaDao.findAll(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final List<Receita> receitas = snapshot.data;
              if (receitas.length == 0) {
                return FutureBuilder(
                  future: widget._ingredienteDao.findAll(),
                  builder: (context, snapshot) {
                    widget._ingredientes = snapshot.data;
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (widget._ingredientes.length == 0) {
                        return TextoAdicionarIngredienteTelaReceita();
                      }
                      return TextoAdicionarReceita();
                    }
                    return CircularProgressIndicator();
                  },
                );
              }
              return ListView.builder(
                  itemCount: receitas.length,
                  itemBuilder: (context, index) {
                    return CartaoReceita(receitas[index], widget._ingredientes);
                  });
            }
            return Center(child: CircularProgressIndicator());
          }),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => {
                if (widget._ingredientes.length == 0)
                  {
                    Scaffold.of(context).showSnackBar(SnackBar(
                        content: RichText(
                            text: TextSpan(children: [
                      TextSpan(text: "Adicione um "),
                      WidgetSpan(child: Icon(Icons.local_cafe)),
                      TextSpan(
                          text: " Ingrediente",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: " primeiro!")
                    ]))))
                  }
                else
                  {abrirTelaDeAdicaoDeReceita()}
              }),
    );
  }

  void abrirTelaDeAdicaoDeReceita() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ReceitaForm(
                  ingredientes: widget._ingredientes,
                  modo: Modo.adicao,
                ))).then((data) => setState(() {}));
  }
}
