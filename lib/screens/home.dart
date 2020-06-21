import 'package:BoleirinhoApp/components/cards/ingrediente.dart';
import 'package:BoleirinhoApp/components/cards/receita.dart';
import 'package:BoleirinhoApp/models/ingrediente.dart';
import 'package:BoleirinhoApp/models/ingrediente_na_receita.dart';
import 'package:BoleirinhoApp/models/receita.dart';
import 'package:BoleirinhoApp/screens/adicionar/ingrediente.dart';
import 'package:BoleirinhoApp/screens/adicionar/receita.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget{
  final List<Receita> _receitas = List();
  final List<Ingrediente> _ingredientes = List();
  final List<IngredienteNaReceita> _ingredientesNaReceita = List();

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> with SingleTickerProviderStateMixin{
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    //TODO: remover estar 3 linhas
    widget._ingredientes.add(Ingrediente("Chocolate", 1.00, "g"));
    widget._ingredientesNaReceita.add(IngredienteNaReceita(widget._ingredientes[0], 500));
    widget._receitas.add(Receita("Bolo de chocolate", "bla bla bla", 15.00, widget._ingredientesNaReceita));
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
          ListView.builder(
            itemCount: widget._receitas.length,
            itemBuilder: (context, index){
              return CartaoReceita(widget._receitas[index]);
            }
          ),
          ListView.builder(
            itemCount: widget._ingredientes.length,
            itemBuilder: (context, index){
              return CartaoIngrediente(widget._ingredientes[index]);
            }
          )
      ],),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => {
          abrirTelaDeAdicao()
        }
      ),
    );
  }

  void abrirTelaDeAdicao(){
    if(_tabController.index == 0){
      Navigator.push(context, MaterialPageRoute(builder: (context) => AdicionarReceita(widget._ingredientes)))
        .then((receita) => {
          if(receita != null){
            setState((){widget._receitas.add(receita);})
          }
      });
      return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) => AdicionarIngrediente()))
      .then((ingrediente) => {
        if(ingrediente != null){
          setState((){widget._ingredientes.add(ingrediente);})
        }
    });
  }
}