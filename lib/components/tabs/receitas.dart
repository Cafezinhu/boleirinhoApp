import 'package:BoleirinhoApp/components/cards/receita.dart';
import 'package:BoleirinhoApp/components/richtext/add_ingrediente_tela_receita.dart';
import 'package:BoleirinhoApp/components/richtext/add_receita.dart';
import 'package:BoleirinhoApp/components/textFields/pesquisa.dart';
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

  TextEditingController _pesquisaController = TextEditingController();
  @override
  _ReceitasTabState createState() {
    return _ReceitasTabState();
  }
}

class _ReceitasTabState extends State<ReceitasTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: widget._ingredienteDao.findAll(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.done) {
              if (snap.data.length > 0) {
                widget._ingredientes = snap.data;
                return FutureBuilder(
                  future: widget._receitaDao.findAll(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.data.length > 0) {
                        ReceitasList _receitasList = ReceitasList(
                            widget._ingredientes,
                            widget._pesquisaController,
                            snapshot.data);
                        return Column(
                          children: <Widget>[
                            Pesquisa(widget._pesquisaController, () {
                              _receitasList.state.setState(() {});
                            }),
                            Expanded(
                              child: _receitasList,
                            ),
                          ],
                        );
                      }
                      return TextoAdicionarReceita();
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                );
              }
              return TextoAdicionarIngredienteTelaReceita();
            }
            return Center(child: CircularProgressIndicator());
          }),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => {
                if (widget._ingredientes.length == 0)
                  {
                    Scaffold.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.orange,
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
                  abrirTelaDeAdicaoDeReceita(context)
              }),
    );
  }

  void abrirTelaDeAdicaoDeReceita(BuildContext ctx) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ReceitaForm(
                  ingredientes: widget._ingredientes,
                  modo: Modo.adicao,
                ))).then((receita) => setState(() {
          if (receita != null) {
            Scaffold.of(ctx).showSnackBar(
              SnackBar(
                  backgroundColor: Colors.green,
                  content: RichText(
                      text: TextSpan(children: [
                    TextSpan(text: "Receita "),
                    TextSpan(
                      text: receita.nome,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: " adicionada com sucesso!")
                  ]))),
            );
          }
        }));
  }
}

class ReceitasList extends StatefulWidget {
  State state = _ReceitasListState();
  List<Ingrediente> _ingredientes;
  TextEditingController _pesquisaController;
  List<Receita> _receitas;

  ReceitasList(this._ingredientes, this._pesquisaController, this._receitas);
  @override
  _ReceitasListState createState() => state;
}

class _ReceitasListState extends State<ReceitasList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget._receitas.length,
        itemBuilder: (context, index) {
          if (widget._pesquisaController.text == null ||
              widget._pesquisaController.text.trim() == "" ||
              widget._receitas[index].nome.toLowerCase().contains(
                  widget._pesquisaController.text.trim().toLowerCase())) {
            return CartaoReceita(widget._receitas[index], widget._ingredientes);
          }
          return Container();
        });
  }
}
