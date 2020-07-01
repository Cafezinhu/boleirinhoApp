import 'package:BoleirinhoApp/database/dao/receita_dao.dart';
import 'package:BoleirinhoApp/models/editor.dart';
import 'package:BoleirinhoApp/models/enums/modo.dart';
import 'package:BoleirinhoApp/models/ingrediente.dart';
import 'package:BoleirinhoApp/models/ingrediente_na_receita.dart';
import 'package:BoleirinhoApp/models/receita.dart';
import 'package:flutter/material.dart';

class ReceitaForm extends StatefulWidget {
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _instrucoesController = TextEditingController();
  List<IngredienteNaReceita> _ingredientesNaReceita = List();
  List<Ingrediente> ingredientes;
  double _custoTotal = 0.0;
  List<TextEditingController> _controladoresIngredientes = List();

  Modo modo;
  Receita receitaRecebida, receita;
  ReceitaForm({this.ingredientes, this.modo, this.receita});

  @override
  _ReceitaFormState createState() {
    if (modo == Modo.edicao) {
      receitaRecebida = Receita.clone(receita);
      _nomeController.text = receitaRecebida.nome;
      _instrucoesController.text = receitaRecebida.instrucoes;
      _ingredientesNaReceita = receitaRecebida.ingredientes;
      _custoTotal = receitaRecebida.calcularPreco();
      for (IngredienteNaReceita i in _ingredientesNaReceita) {
        TextEditingController controller = TextEditingController();
        controller.text = i.quantidade.toString();
        _controladoresIngredientes.add(controller);
      }
    }
    return _ReceitaFormState();
  }
}

class _ReceitaFormState extends State<ReceitaForm> {
  ReceitaDao dao = ReceitaDao();
  List<Widget> _seletoresDeIngredientes;

  @override
  Widget build(BuildContext context) {
    _seletoresDeIngredientes = List();

    for (Ingrediente ingrediente in widget.ingredientes) {
      _seletoresDeIngredientes.add(SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, ingrediente);
          },
          child: Text(ingrediente.nome, style: TextStyle(fontSize: 24.0))));
    }

    return Scaffold(
        appBar: AppBar(title: Text('Adicionar Receita')),
        body: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: widget._ingredientesNaReceita.length + 2,
            itemBuilder: (context, index) {
              if (index == 0)
                return Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Editor(
                        label: "Nome",
                        controller: widget._nomeController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: "Instruções",
                        ),
                        style: TextStyle(fontSize: 24.0),
                        minLines: 3,
                        maxLines: null,
                        controller: widget._instrucoesController,
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.local_cafe),
                        title: Text(
                          "Ingredientes:",
                          style: TextStyle(fontSize: 24.0),
                        ),
                      ),
                    )
                  ],
                );
              else if (index < widget._ingredientesNaReceita.length + 1) {
                return Card(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.local_cafe),
                        trailing: Icon(Icons.edit),
                        title: Text(
                            widget._ingredientesNaReceita[index - 1].ingrediente
                                .nome,
                            style: TextStyle(fontSize: 24.0)),
                        onTap: () {
                          abrirSelecaoIngrediente("Editar Ingrediente")
                              .then((ingrediente) => {
                                    if (ingrediente != null)
                                      {
                                        setState(() {
                                          widget
                                              ._ingredientesNaReceita[index - 1]
                                              .ingrediente = ingrediente;
                                          _calcularCustoTotal();
                                        })
                                      }
                                  });
                        },
                      ),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller:
                                widget._controladoresIngredientes[index - 1],
                            decoration: InputDecoration(
                                labelText: widget
                                            ._ingredientesNaReceita[index - 1]
                                            .ingrediente
                                            .unidade ==
                                        "unidade"
                                    ? "Quantidade"
                                    : ("Quantidade (" +
                                        widget._ingredientesNaReceita[index - 1]
                                            .ingrediente.unidade +
                                        ")"),
                                hintText: widget
                                            ._ingredientesNaReceita[index - 1]
                                            .ingrediente
                                            .unidade ==
                                        "unidade"
                                    ? "0"
                                    : "0.00"),
                            style: TextStyle(fontSize: 24.0),
                            keyboardType: TextInputType.number,
                            onChanged: (valor) {
                              setState(() {
                                if (valor != null) {
                                  widget._ingredientesNaReceita[index - 1]
                                      .quantidade = double.tryParse(valor);
                                  _calcularCustoTotal();
                                } else {
                                  widget._ingredientesNaReceita[index - 1]
                                      .quantidade = 0;
                                  _calcularCustoTotal();
                                }
                              });
                            },
                          )),
                      ListTile(
                          leading: Icon(Icons.monetization_on),
                          title: Text(
                              "Custo: " +
                                  widget._ingredientesNaReceita[index - 1]
                                      .precoExtensao(),
                              style: TextStyle(fontSize: 24.0))),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.delete),
                                Text("Remover")
                              ],
                            ),
                            color: Colors.red,
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("Remover"),
                                      content: Text("Deseja remover " +
                                          widget
                                              ._ingredientesNaReceita[index - 1]
                                              .ingrediente
                                              .nome +
                                          " desta receita?"),
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
                                        )
                                      ],
                                    );
                                  }).then((valor) {
                                if (valor) {
                                  setState(() {
                                    widget._ingredientesNaReceita.remove(widget
                                        ._ingredientesNaReceita[index - 1]);
                                    _calcularCustoTotal();
                                  });
                                }
                              });
                            }),
                      )
                    ],
                  ),
                );
              }

              return Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: RaisedButton(
                        onPressed: () {
                          abrirSelecaoIngrediente("Adicionar Ingrediente")
                              .then((ingrediente) => {
                                    if (ingrediente != null)
                                      {
                                        setState(() {
                                          widget._ingredientesNaReceita.add(
                                              IngredienteNaReceita(
                                                  ingrediente: ingrediente,
                                                  quantidade: 0.0));
                                        })
                                      }
                                  });
                        },
                        child: Text("Adicionar Ingrediente")),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.monetization_on),
                      title: Text(
                          "Custo total: R\$" + widget._custoTotal.toString(),
                          style: TextStyle(fontSize: 24.0)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 8.0),
                    child: RaisedButton(
                        onPressed: () {
                          String nome = widget._nomeController.text;
                          String instrucoes =
                              widget._instrucoesController.text != null
                                  ? widget._instrucoesController.text
                                  : "";
                          List<IngredienteNaReceita> ingredientes =
                              widget._ingredientesNaReceita;
                          if (nome != null) {
                            if (widget.modo == Modo.adicao) {
                              dao
                                  .save(Receita(
                                      0, nome, instrucoes, ingredientes))
                                  .then((value) => Navigator.pop(context));
                            } else {
                              Receita r = Receita(widget.receita.id, nome,
                                  instrucoes, ingredientes);
                              dao.update(r).then((value) => Navigator.pop(
                                    context, r
                                  ));
                            }
                          }
                        },
                        child: Text("Salvar Receita")),
                  )
                ],
              );
            }));
  }

  void _calcularCustoTotal() {
    double custo = 0.0;
    for (IngredienteNaReceita ingrediente in widget._ingredientesNaReceita) {
      custo += ingrediente.calcularPreco();
    }
    widget._custoTotal = custo;
  }

  Future<Ingrediente> abrirSelecaoIngrediente(String titulo) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
              title: Text(titulo), children: _seletoresDeIngredientes);
        });
  }
}
