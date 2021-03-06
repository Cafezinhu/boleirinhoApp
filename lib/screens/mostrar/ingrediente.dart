import 'package:BoleirinhoApp/database/dao/ingredienteNaReceita_dao.dart';
import 'package:BoleirinhoApp/database/dao/ingrediente_dao.dart';
import 'package:BoleirinhoApp/models/enums/modo.dart';
import 'package:BoleirinhoApp/models/ingrediente.dart';
import 'package:BoleirinhoApp/models/receita.dart';
import 'package:BoleirinhoApp/screens/form/ingrediente.dart';
import 'package:flutter/material.dart';

class MostrarIngrediente extends StatefulWidget {
  Ingrediente _ingrediente;
  MostrarIngrediente(this._ingrediente);
  @override
  _MostrarIngredienteState createState() => _MostrarIngredienteState();
}

class BotaoEditarIngrediente extends StatelessWidget {
  Ingrediente _ingrediente;
  Function _callback;
  BotaoEditarIngrediente(this._ingrediente, this._callback);
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) => IngredienteForm(
                      modo: Modo.edicao,
                      ingrediente: _ingrediente,
                    ))).then((ingrediente) {
          if (ingrediente != null) {
            Scaffold.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.green,
              content: Text("Ingrediente atualizado com sucesso!"),
            ));
            _callback(ingrediente);
          }
        });
      },
      child: Icon(Icons.edit),
    );
  }
}

class _MostrarIngredienteState extends State<MostrarIngrediente> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._ingrediente.nome),
      ),
      floatingActionButton:
          BotaoEditarIngrediente(widget._ingrediente, (ingrediente) {
        setState(() {
          widget._ingrediente = ingrediente;
        });
      }),
      body: ListView(
        children: <Widget>[
          Card(
            child: ListTile(
                title: Text("Unidade:"),
                subtitle: Text(widget._ingrediente.unidade),
                leading: Icon(Icons.local_cafe)),
          ),
          Card(
            child: ListTile(
              title: Text("Preço por unidade:"),
              subtitle:
                  Text("R\$" + widget._ingrediente.precoPorUnidade.toString()),
              leading: Icon(Icons.monetization_on),
            ),
          ),
          Padding(
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
                          title: Text("Apagar Ingrediente"),
                          content: Text(
                              "Deseja apagar ${widget._ingrediente.nome}?"),
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
                      IngredienteNaReceitaDao()
                          .findReceitasByIngredienteId(widget._ingrediente.id)
                          .then((receitas) {
                        if (receitas.length > 0) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              String receitasString = "";
                              for (Receita receita in receitas) {
                                receitasString += " ${receita.nome},";
                              }
                              receitasString.substring(
                                  0, receitasString.length - 3);
                              return AlertDialog(
                                title: Text(
                                    "Não foi possível apagar ${widget._ingrediente.nome}"),
                                content: Text(
                                    "${widget._ingrediente.nome} está sendo usado em$receitasString"),
                                actions: <Widget>[
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Ok"),
                                  )
                                ],
                              );
                            },
                          );
                          return;
                        }
                        IngredienteDao()
                            .delete(widget._ingrediente.id)
                            .then((value) => Navigator.pop(context, true));
                      });
                    }
                  });
                }),
          ),
        ],
      ),
    );
  }
}
