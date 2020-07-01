import 'package:BoleirinhoApp/components/tabs/ingredientes.dart';
import 'package:BoleirinhoApp/components/tabs/receitas.dart';
import 'package:BoleirinhoApp/database/dao/ingrediente_dao.dart';
import 'package:BoleirinhoApp/database/dao/receita_dao.dart';
import 'package:BoleirinhoApp/models/ingrediente.dart';
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
          ReceitasTab(ingredienteDao, receitaDao, _ingredientes),
          IngredientesTab(ingredienteDao, _ingredientes)
        ],
      ),
    );
  }
}
