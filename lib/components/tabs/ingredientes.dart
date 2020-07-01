import 'package:BoleirinhoApp/components/cards/ingrediente.dart';
import 'package:BoleirinhoApp/components/richtext/add_ingrediente.dart';
import 'package:BoleirinhoApp/database/dao/ingrediente_dao.dart';
import 'package:BoleirinhoApp/models/enums/modo.dart';
import 'package:BoleirinhoApp/models/ingrediente.dart';
import 'package:BoleirinhoApp/screens/form/ingrediente.dart';
import 'package:flutter/material.dart';

class IngredientesTab extends StatefulWidget {
  IngredienteDao _ingredienteDao;
  List<Ingrediente> _ingredientes;
  IngredientesTab(this._ingredienteDao, this._ingredientes);
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
            widget._ingredientes = snapshot.data;
            if (widget._ingredientes.length == 0) {
              return TextoAdicionarIngrediente();
            }
            return ListView.builder(
                itemCount: widget._ingredientes.length,
                itemBuilder: (context, index) {
                  return CartaoIngrediente(widget._ingredientes[index]);
                });
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            abrirTelaAdicaoIngrediente();
          }),
    );
  }

  void abrirTelaAdicaoIngrediente() {
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => IngredienteForm(modo: Modo.adicao)))
        .then((data) => {setState(() {})});
  }
}
