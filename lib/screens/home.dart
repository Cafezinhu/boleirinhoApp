import 'package:BoleirinhoApp/components/cards/ingrediente.dart';
import 'package:BoleirinhoApp/components/cards/receita.dart';
import 'package:BoleirinhoApp/components/richtext/add_ingrediente.dart';
import 'package:BoleirinhoApp/components/richtext/add_ingrediente_tela_receita.dart';
import 'package:BoleirinhoApp/components/richtext/add_receita.dart';
import 'package:BoleirinhoApp/database/dao/ingrediente_dao.dart';
import 'package:BoleirinhoApp/database/dao/receita_dao.dart';
import 'package:BoleirinhoApp/models/enums/modo.dart';
import 'package:BoleirinhoApp/models/ingrediente.dart';
import 'package:BoleirinhoApp/models/receita.dart';
import 'package:BoleirinhoApp/screens/form/ingrediente.dart';
import 'package:BoleirinhoApp/screens/form/receita.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController _tabController;
  IngredienteDao ingredienteDao = IngredienteDao();
  ReceitaDao receitaDao = ReceitaDao();
  List<Ingrediente> _ingredientes = List();

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    ingredienteDao
        .findAll()
        .then((ingredientes) => _ingredientes = ingredientes);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Boleirinho"),
        bottom: TabBar(controller: _tabController, tabs: <Widget>[
          Tab(
            icon: Icon(Icons.cake),
            text: "Receitas",
          ),
          Tab(
            icon: Icon(Icons.local_cafe),
            text: "Ingredientes",
          )
        ]),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Scaffold(
            body: FutureBuilder(
                future: receitaDao.findAll(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    final List<Receita> receitas = snapshot.data;
                    if (receitas.length == 0) {
                      return FutureBuilder(
                        future: ingredienteDao.findAll(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            List<Ingrediente> ingredientes = snapshot.data;
                            if (ingredientes.length == 0) {
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
                          return CartaoReceita(receitas[index], _ingredientes);
                        });
                  }
                  return Center(child: CircularProgressIndicator());
                }),
            floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () => {abrirTelaDeAdicaoDeReceita()}),
          ),
          Scaffold(
            body: FutureBuilder(
              future: ingredienteDao.findAll(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  _ingredientes = snapshot.data;
                  if (_ingredientes.length == 0) {
                    return TextoAdicionarIngrediente();
                  }
                  return ListView.builder(
                      itemCount: _ingredientes.length,
                      itemBuilder: (context, index) {
                        return CartaoIngrediente(_ingredientes[index]);
                      });
                }

                return Center(child: CircularProgressIndicator());
              },
            ),
            floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  IngredienteForm(modo: Modo.adicao)))
                      .then((data) => {setState(() {})});
                }),
          )
        ],
      ),
    );
  }

  void abrirTelaDeAdicaoDeReceita() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ReceitaForm(
                  ingredientes: _ingredientes,
                ))).then((data) => setState(() {}));
  }

  void abrirTelaDeAdicaoDeIngrediente() {}
}
