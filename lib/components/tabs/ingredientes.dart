import 'package:BoleirinhoApp/components/cards/ingrediente.dart';
import 'package:BoleirinhoApp/components/richtext/add_ingrediente.dart';
import 'package:BoleirinhoApp/components/textFields/pesquisa.dart';
import 'package:BoleirinhoApp/database/dao/ingrediente_dao.dart';
import 'package:BoleirinhoApp/models/enums/modo.dart';
import 'package:BoleirinhoApp/models/ingrediente.dart';
import 'package:BoleirinhoApp/screens/form/ingrediente.dart';
import 'package:flutter/material.dart';

class IngredientesTab extends StatefulWidget {
  IngredienteDao _ingredienteDao;
  List<Ingrediente> _ingredientes;
  IngredientesTab(this._ingredienteDao, this._ingredientes);

  TextEditingController _pesquisaController = TextEditingController();
  @override
  _IngredientesTabState createState() => _IngredientesTabState();
}

class _IngredientesTabState extends State<IngredientesTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: widget._ingredienteDao.findAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data.length > 0) {
              IngredientesList _ingredientesList =
                  IngredientesList(snapshot.data, widget._pesquisaController);
              return Column(
                children: <Widget>[
                  Pesquisa(widget._pesquisaController, () {
                    _ingredientesList.state.setState(() {});
                  }),
                  Expanded(child: _ingredientesList)
                ],
              );
            }
            return TextoAdicionarIngrediente();
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            abrirTelaAdicaoIngrediente(context);
          }),
    );
  }

  void abrirTelaAdicaoIngrediente(BuildContext ctx) {
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => IngredienteForm(modo: Modo.adicao)))
        .then((ingrediente) => {
              setState(() {
                if (ingrediente != null) {
                  Scaffold.of(ctx).showSnackBar(
                    SnackBar(
                        backgroundColor: Colors.green,
                        content: RichText(
                            text: TextSpan(children: [
                          TextSpan(text: "Ingrediente "),
                          TextSpan(
                            text: ingrediente.nome,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: " adicionado com sucesso!")
                        ]))),
                  );
                }
              })
            });
  }
}

class IngredientesList extends StatefulWidget {
  State state = _IngredientesListState();

  List<Ingrediente> _ingredientes;
  TextEditingController _pesquisaController;

  IngredientesList(this._ingredientes, this._pesquisaController);

  @override
  _IngredientesListState createState() => state;
}

class _IngredientesListState extends State<IngredientesList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget._ingredientes.length,
        itemBuilder: (context, index) {
          if (widget._pesquisaController.text == null ||
              widget._pesquisaController.text.trim() == "" ||
              widget._ingredientes[index].nome.toLowerCase().contains(
                  widget._pesquisaController.text.trim().toLowerCase())) {
            return CartaoIngrediente(widget._ingredientes[index]);
          }
          return Container();
        });
  }
}
