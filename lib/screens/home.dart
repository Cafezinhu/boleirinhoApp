import 'package:BoleirinhoApp/components/cards/ingrediente.dart';
import 'package:BoleirinhoApp/components/cards/receita.dart';
import 'package:BoleirinhoApp/database/dao/ingrediente_dao.dart';
import 'package:BoleirinhoApp/database/dao/receita_dao.dart';
import 'package:BoleirinhoApp/models/ingrediente.dart';
import 'package:BoleirinhoApp/models/receita.dart';
import 'package:BoleirinhoApp/screens/adicionar/ingrediente.dart';
import 'package:BoleirinhoApp/screens/adicionar/receita.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget{
  final List<Receita> _receitas = List();
  final List<Ingrediente> _ingredientes = List();

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> with SingleTickerProviderStateMixin{
  TabController _tabController;
  IngredienteDao ingredienteDao = IngredienteDao();
  ReceitaDao receitaDao = ReceitaDao();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        bottom: TabBar(
          controller: _tabController,
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.cake),
              text: "Receitas",
            ),
            Tab(
              icon: Icon(Icons.local_cafe),
              text: "Ingredientes",
            )
          ]
          ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Scaffold(
            body: ListView.builder(
              itemCount: widget._receitas.length,
              itemBuilder: (context, index){
                return CartaoReceita(widget._receitas[index]);
              }
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => {
                abrirTelaDeAdicaoDeReceita()
              }
            ),
          ),
          Scaffold(
            body: FutureBuilder(
              future: ingredienteDao.findAll(),
              builder: (context, snapshot){
                if(snapshot.connectionState == ConnectionState.done){
                  final List<Ingrediente> ingredientes = snapshot.data;
                  return ListView.builder(
                    itemCount: ingredientes.length,
                    itemBuilder: (context, index){
                      return CartaoIngrediente(ingredientes[index]);
                    }
                  );
                }

                return Center(
                    child: CircularProgressIndicator()
                  );
              },
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => AdicionarIngrediente()))
                  .then((data) => {setState((){})});
              }
            ),
          )
        ],
      ),
    );
  }

  void abrirTelaDeAdicaoDeReceita(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => AdicionarReceita(widget._ingredientes)))
      .then((receita) => {
        if(receita != null){
          setState((){widget._receitas.add(receita);}),
        }
    });
  }

  void abrirTelaDeAdicaoDeIngrediente(){
    
  }
}