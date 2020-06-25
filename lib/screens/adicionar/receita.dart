import 'package:BoleirinhoApp/database/dao/receita_dao.dart';
import 'package:BoleirinhoApp/models/editor.dart';
import 'package:BoleirinhoApp/models/ingrediente.dart';
import 'package:BoleirinhoApp/models/ingrediente_na_receita.dart';
import 'package:BoleirinhoApp/models/receita.dart';
import 'package:flutter/material.dart';

class AdicionarReceita extends StatefulWidget {
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _instrucoesController = TextEditingController();
  List<IngredienteNaReceita> _ingredientesNaReceita = List();
  List<Ingrediente> _ingredientes;
  double _custoTotal = 0.0;

  AdicionarReceita(this._ingredientes);

  @override
  _AdicionarReceitaState createState() => _AdicionarReceitaState();

}

class _AdicionarReceitaState extends State<AdicionarReceita> {
  ReceitaDao dao = ReceitaDao();
  List<Widget> _seletoresDeIngredientes;
  @override
  Widget build(BuildContext context) {
    _seletoresDeIngredientes = List();

    for (Ingrediente ingrediente in widget._ingredientes){
      _seletoresDeIngredientes.add(
        SimpleDialogOption(
          onPressed: (){
            Navigator.pop(context, ingrediente);
          },
          child: Text(ingrediente.nome, 
            style: TextStyle(
              fontSize: 24.0
            )
          )
        )
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Receita')
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: widget._ingredientesNaReceita.length + 2,
        itemBuilder: (context, index){
          if(index == 0)
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
                    style: TextStyle(
                      fontSize: 24.0
                    ),
                    minLines: 3,
                    maxLines: null,
                    controller: widget._instrucoesController,
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.local_cafe),
                    title: Text("Ingredientes:",
                      style: TextStyle(
                        fontSize: 24.0
                      )
                    ,),
                  ),
                )
              ],
            );
          else if(index < widget._ingredientesNaReceita.length + 1){
            return Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.local_cafe),
                    trailing: Icon(Icons.edit),
                    title: Text(widget._ingredientesNaReceita[index-1].ingrediente.nome,
                      style: TextStyle(
                        fontSize: 24.0
                      )
                    ),
                    onTap: () {
                      abrirSelecaoIngrediente("Editar Ingrediente")
                        .then(
                          (ingrediente) => {
                            if(ingrediente != null){
                              setState((){
                                widget._ingredientesNaReceita[index-1].ingrediente = ingrediente;
                                _calcularCustoTotal();
                              })
                            }
                          }
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: widget._ingredientesNaReceita[index-1].ingrediente.unidade == "unidade" ? "Quantidade" : ("Quantidade (" 
                          + widget._ingredientesNaReceita[index-1].ingrediente.unidade
                          + ")"),
                        hintText: widget._ingredientesNaReceita[index-1].ingrediente.unidade == "unidade" ? "0" : "0.00"
                      ),
                      style: TextStyle(
                        fontSize: 24.0
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (valor){
                        setState(() {
                          widget._ingredientesNaReceita[index-1].quantidade = double.tryParse(valor);
                          _calcularCustoTotal();
                        });
                      },
                    )
                  ),
                  ListTile(
                    leading: Icon(Icons.monetization_on),
                    title: Text("Custo: " + widget._ingredientesNaReceita[index-1].precoExtensao(),
                      style: TextStyle(
                          fontSize: 24.0
                        )
                    )
                  ),
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
                      onPressed: (){
                        showDialog(
                          context: context,
                          builder: (context){
                            return AlertDialog(
                              title: Text("Remover"),
                              content: Text("Deseja remover " 
                                + widget._ingredientesNaReceita[index-1].ingrediente.nome 
                                + " desta receita?"),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text("Não"),
                                  onPressed: (){
                                    Navigator.pop(context, false);
                                  },
                                ),
                                FlatButton(
                                  child: Text("Sim"),
                                  onPressed: (){
                                    Navigator.pop(context, true);
                                  },
                                )
                              ],
                            );
                          }
                        ).then((valor) {
                          if(valor){
                            setState(() {
                              widget._ingredientesNaReceita.remove(widget._ingredientesNaReceita[index-1]);
                              _calcularCustoTotal();
                            });
                          }
                        });
                      }
                    ),
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
                  onPressed: (){
                    abrirSelecaoIngrediente("Adicionar Ingrediente")
                      .then(
                        (ingrediente) => {
                          if(ingrediente != null){
                            setState((){widget._ingredientesNaReceita.add(IngredienteNaReceita(ingrediente, 0.0));})
                          }
                        }
                    );
                  }, 
                  child: Text("Adicionar Ingrediente")
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.monetization_on),
                  title: Text("Custo total: R\$" + widget._custoTotal.toString(),
                    style: TextStyle(
                      fontSize: 24.0
                    )
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                child: RaisedButton(
                  onPressed: (){
                    String nome = widget._nomeController.text;
                    String instrucoes = widget._instrucoesController.text != null ? widget._instrucoesController.text : "";
                    double preco = widget._custoTotal;
                    List<IngredienteNaReceita> ingredientes = widget._ingredientesNaReceita;
                    if(nome != null)
                      dao.save(Receita(0, nome, instrucoes, preco, ingredientes)).then((value) => Navigator.pop(context));
                  }, 
                  child: Text("Salvar Receita")
                ),
              )
            ],
          );
        }
      )
    );
  }

  void _calcularCustoTotal(){
    double custo = 0.0;
    for (IngredienteNaReceita ingrediente in widget._ingredientesNaReceita) {
      custo += ingrediente.calcularPreco();
    }
    widget._custoTotal = custo;
  }
  
  Future<Ingrediente> abrirSelecaoIngrediente(String titulo){
    return showDialog(
      context: context,
      builder: (context){
        return SimpleDialog(
          title: Text("Editar Ingrediente"),
          children: _seletoresDeIngredientes
        );
      }
    );
  }
}