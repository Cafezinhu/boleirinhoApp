import 'package:BoleirinhoApp/models/editor.dart';
import 'package:BoleirinhoApp/models/ingrediente.dart';
import 'package:BoleirinhoApp/utils/math.dart';
import 'package:flutter/material.dart';

class AdicionarIngrediente extends StatefulWidget {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _precoController = TextEditingController();
  final TextEditingController _calculadoraPrecoController = TextEditingController();
  final TextEditingController _calculadoraQuantidadeController = TextEditingController();
  @override
  _AdicionarIngredienteState createState() => _AdicionarIngredienteState();
}

enum Unidade {unidade, g, mL}

class _AdicionarIngredienteState extends State<AdicionarIngrediente> {
  Unidade _unidade = Unidade.unidade;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adicionar Ingrediente")
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        children: <Widget>[
          Editor(
            label: "Nome",
            controller: widget._nomeController
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text.rich(
                    TextSpan(
                      text: "Unidade:",
                      style: TextStyle(
                        fontSize: 24.0,
                      )
                    )
                  ),
                ),
              ),
              ListTile(
                title: Text("unidade"),
                leading: Radio(
                  value: Unidade.unidade, 
                  groupValue: _unidade, 
                  onChanged: (Unidade value){
                    setState(() {
                      _unidade = value;
                    });
                  }
                ),
              ),
              ListTile(
                title: Text("g"),
                leading: Radio(
                  value: Unidade.g, 
                  groupValue: _unidade, 
                  onChanged: (Unidade value){
                    setState(() {
                      _unidade = value;
                    });
                  }
                ),
              ),
              ListTile(
                title: Text("mL"),
                leading: Radio(
                  value: Unidade.mL, 
                  groupValue: _unidade, 
                  onChanged: (Unidade value){
                    setState(() {
                      _unidade = value;
                    });
                  }
                ),
              ),
            ]
          ),
          Card(
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text("Calculadora de preço"),
                  trailing: Icon(Icons.help_outline),
                  onTap: (){

                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Editor(
                        label: "Preço do produto",
                        hint: "0.00",
                        controller: widget._calculadoraPrecoController,
                        keyboardType: TextInputType.number,
                        onChanged: _calcularPrecoPorQuantidade(),
                      ),
                      Editor(
                        label: "Quantidade em " + _unidade.toString().split(".")[1],
                        hint: "0.00",
                        controller: widget._calculadoraQuantidadeController,
                        keyboardType: TextInputType.number,
                        onChanged: _calcularPrecoPorQuantidade(),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Editor(
            label: "Preço por " + _unidade.toString().split(".")[1],
            hint: "0.00",
            icon: Icon(Icons.monetization_on),
            controller: widget._precoController,
            keyboardType: TextInputType.number,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 16.0),
            child: RaisedButton(
              child: Text("Salvar Ingrediente"),
              onPressed: () {
                _retornarDados(context);
              }
            ),
          )
        ],
        )
    );
  }

  Function _calcularPrecoPorQuantidade(){
    return (String _){
      final double preco = double.tryParse(widget._calculadoraPrecoController.text);
      final double quantidade = double.tryParse(widget._calculadoraQuantidadeController.text);

      if(preco != null && quantidade != null){
        if(preco >= 0 && quantidade > 0){
          setState(() {
            widget._precoController.text = MathUtils.doubleToString(preco/quantidade, 2);
          });
        }
      }
    };
  }

  void _retornarDados(BuildContext context){
    final String nome = widget._nomeController.text;
    final double preco = double.tryParse(widget._precoController.text);
    final String unidade = _unidade.toString().split(".")[1];
    if(nome != null && preco != null && unidade != null){
      Navigator.pop(context, Ingrediente(nome, preco, unidade));
    }
  }
}