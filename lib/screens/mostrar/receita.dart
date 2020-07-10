import 'package:BoleirinhoApp/components/cards/ingrediente_na_receita.dart';
import 'package:BoleirinhoApp/database/dao/receita_dao.dart';
import 'package:BoleirinhoApp/models/enums/modo.dart';
import 'package:BoleirinhoApp/models/ingrediente.dart';
import 'package:BoleirinhoApp/models/receita.dart';
import 'package:BoleirinhoApp/screens/form/receita.dart';
import 'package:flutter/material.dart';

class MostrarReceita extends StatefulWidget {
  final List<Ingrediente> ingredientes;
  Receita _receita;
  MostrarReceita(this._receita, this.ingredientes);
  @override
  _MostrarReceitaState createState() => _MostrarReceitaState();
}

class BotaoEditarReceita extends StatelessWidget {
  List<Ingrediente> _ingredientes;
  Receita _receita;
  Function _callback;
  BotaoEditarReceita(this._ingredientes, this._receita, this._callback);
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) => ReceitaForm(
                    ingredientes: _ingredientes,
                    modo: Modo.edicao,
                    receita: _receita))).then((receita) {
          if (receita != null) {
            Scaffold.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.green,
              content: Text("Receita atualizada com sucesso!"),
            ));
            _callback(receita);
          }
        });
      },
      child: Icon(Icons.edit),
    );
  }
}

class _MostrarReceitaState extends State<MostrarReceita> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget._receita.nome),
        ),
        floatingActionButton:
            BotaoEditarReceita(widget.ingredientes, widget._receita, (receita) {
          setState(() {
            widget._receita = receita;
          });
        }),
        body: ListView.builder(
            itemCount: widget._receita.ingredientes.length + 2,
            itemBuilder: (context, index) {
              if (index == 0)
                return Column(children: <Widget>[
                  Card(
                    child: ListTile(
                      title: Text("Preço unitário: R\$" +
                          widget._receita
                              .calcularPrecoDeRendimento()
                              .toString() +
                          "\nPreço total: R\$" +
                          widget._receita.calcularCustoTotal().toString()),
                      leading: Icon(Icons.monetization_on),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text("Modo de preparo:"),
                      subtitle: Text(widget._receita.instrucoes),
                      leading: Icon(Icons.cake),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text("Ingredientes: "),
                    ),
                  ),
                ]);
              else if (index < widget._receita.ingredientes.length + 1)
                return CartaoIngredienteNaReceita(
                    widget._receita.ingredientes[index - 1]);

              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 8.0,
                ),
                child: RaisedButton(
                    color: Colors.red,
                    child: Row(children: <Widget>[
                      Icon(Icons.delete),
                      Text("Apagar"),
                    ]),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Apagar Receita"),
                              content: Text(
                                  "Deseja apagar ${widget._receita.nome}?"),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text("Não"),
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  },
                                ),
                                FlatButton(
                                  child: Text("Sim"),
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                ),
                              ],
                            );
                          }).then((value) {
                        if (value) {
                          ReceitaDao()
                              .delete(widget._receita.id)
                              .then((value) => Navigator.pop(context, true));
                        }
                      });
                    }),
              );
            }));
  }
}
