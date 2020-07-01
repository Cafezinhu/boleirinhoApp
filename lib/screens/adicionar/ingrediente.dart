import 'package:BoleirinhoApp/database/dao/ingrediente_dao.dart';
import 'package:BoleirinhoApp/models/editor.dart';
import 'package:BoleirinhoApp/models/enums/modo.dart';
import 'package:BoleirinhoApp/models/enums/unidade.dart';
import 'package:BoleirinhoApp/models/ingrediente.dart';
import 'package:BoleirinhoApp/utils/math.dart';
import 'package:flutter/material.dart';

class IngredienteForm extends StatefulWidget {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _precoController = TextEditingController();
  final TextEditingController _calculadoraPrecoController =
      TextEditingController();
  final TextEditingController _calculadoraQuantidadeController =
      TextEditingController();

  Modo modo;
  Ingrediente ingrediente;
  int _id;
  Unidade _unidade = Unidade.unidade;

  IngredienteForm({this.modo, this.ingrediente});
  @override
  _IngredienteFormState createState() {
    if (modo == Modo.edicao) {
      _nomeController.text = ingrediente.nome;
      _precoController.text = ingrediente.precoPorUnidade.toString();
      _id = ingrediente.id;
      _unidade = UnidadeExtension.fromString(ingrediente.unidade);
    }
    return _IngredienteFormState();
  }
}

class _IngredienteFormState extends State<IngredienteForm> {
  IngredienteDao dao = IngredienteDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(widget.modo == Modo.adicao
                ? "Adicionar Ingrediente"
                : "Editar Ingrediente")),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          children: <Widget>[
            Editor(label: "Nome", controller: widget._nomeController),
            Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text.rich(TextSpan(
                      text: "Unidade:",
                      style: TextStyle(
                        fontSize: 24.0,
                      ))),
                ),
              ),
              ListTile(
                title: Text("unidade"),
                leading: Radio(
                    value: Unidade.unidade,
                    groupValue: widget._unidade,
                    onChanged: (Unidade value) {
                      setState(() {
                        widget._unidade = value;
                      });
                    }),
              ),
              ListTile(
                title: Text("g"),
                leading: Radio(
                    value: Unidade.g,
                    groupValue: widget._unidade,
                    onChanged: (Unidade value) {
                      setState(() {
                        widget._unidade = value;
                      });
                    }),
              ),
              ListTile(
                title: Text("mL"),
                leading: Radio(
                    value: Unidade.mL,
                    groupValue: widget._unidade,
                    onChanged: (Unidade value) {
                      setState(() {
                        widget._unidade = value;
                      });
                    }),
              ),
            ]),
            Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text("Calculadora de preço",
                        style: TextStyle(fontSize: 24.0)),
                    trailing: Icon(Icons.help_outline),
                    onTap: () {},
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
                          label: "Quantidade em " + widget._unidade.stringfy(),
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
              label: "Preço por " + widget._unidade.stringfy(),
              hint: "0.00",
              icon: Icon(Icons.monetization_on),
              controller: widget._precoController,
              keyboardType: TextInputType.number,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 40.0, horizontal: 16.0),
              child: RaisedButton(
                  child: Text("Salvar Ingrediente"),
                  onPressed: () {
                    final String nome = widget._nomeController.text;
                    final double preco =
                        double.tryParse(widget._precoController.text);
                    final String unidade = widget._unidade.stringfy();
                    if (nome != null && preco != null && unidade != null) {
                      if (widget.modo == Modo.adicao) {
                        dao
                            .save(Ingrediente(0, nome, preco, unidade))
                            .then((id) => Navigator.pop(context));
                      } else {
                        Ingrediente novoIngrediente =
                            Ingrediente(widget._id, nome, preco, unidade);
                        dao.update(novoIngrediente).then(
                            (value) => Navigator.pop(context, novoIngrediente));
                      }
                    }
                  }),
            )
          ],
        ));
  }

  Function _calcularPrecoPorQuantidade() {
    return (String _) {
      final double preco =
          double.tryParse(widget._calculadoraPrecoController.text);
      final double quantidade =
          double.tryParse(widget._calculadoraQuantidadeController.text);

      if (preco != null && quantidade != null) {
        if (preco >= 0 && quantidade > 0) {
          setState(() {
            widget._precoController.text =
                MathUtils.doubleToString(preco / quantidade, 2);
          });
        }
      }
    };
  }
}
