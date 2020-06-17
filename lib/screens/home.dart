import 'package:BoleirinhoApp/components/cards/ingrediente.dart';
import 'package:BoleirinhoApp/components/cards/receita.dart';
import 'package:BoleirinhoApp/models/ingrediente.dart';
import 'package:BoleirinhoApp/models/ingrediente_na_receita.dart';
import 'package:BoleirinhoApp/models/receita.dart';
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

class HomeState extends State<Home>{
  DefaultTabController _tabController;
  @override
  Widget build(BuildContext context) {
    widget._ingredientes.add(Ingrediente("Chocolate", 1.00, "g"));
    widget._ingredientesNaReceita.add(IngredienteNaReceita(widget._ingredientes[0], 500));
    widget._receitas.add(Receita("Bolo de chocolate", "bla bla bla", 15.00, widget._ingredientesNaReceita));
    _tabController = DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Boleirinho"),
          bottom: TabBar(
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
        body: TabBarView(children: <Widget>[
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
          onPressed: () => {
            abrirTelaComNumero()
          }
        ),
      )
    );
    return _tabController;
  }

  void abrirTelaComNumero(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => Teste(_tabController.initialIndex)));
  }
}
class Teste extends StatefulWidget {
  final int _numero;
  Teste(this._numero);
  @override
  _TesteState createState() => _TesteState();
}

class _TesteState extends State<Teste> {
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(widget._numero.toString()),
    );
  }
}