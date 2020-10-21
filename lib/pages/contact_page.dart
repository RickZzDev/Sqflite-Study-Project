import 'package:flutter/material.dart';
import 'package:sqflite_project/helpers/database_helper.dart';
import 'package:sqflite_project/models/myModel.dart';

class ContactPage extends StatefulWidget {
  final Contact contato;
  ContactPage({this.contato});

  @override
  _ContactPage createState() => _ContactPage();
}

class _ContactPage extends State<ContactPage> {
  DataBaseHelper db = DataBaseHelper();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();

  bool editando = false;
  Contact _editaContato;

  @override
  void initState() {
    super.initState();
    if (widget.contato == null) {
      _editaContato = Contact(0, "", "");
    } else {
      setState(() {
        editando = true;
      });
      _editaContato = Contact.fromMap(widget.contato.toMap());
      _nomeController.text = _editaContato.nome;
      _emailController.text = _editaContato.email;
    }
    // db.getAllContatos().then((value) => {
    //       setState(() {
    //         contatos = value;
    //       })
    //     });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Padding(
          padding: EdgeInsets.all(10.00),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width - 60,
                    child: TextField(
                      controller: _nomeController,
                      onChanged: (value) {
                        setState(() {
                          _editaContato.nome = value;
                        });
                      },
                      decoration: InputDecoration(hintText: "Nome"),
                    ),
                  ),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width - 60,
                    child: TextField(
                      controller: _emailController,
                      onChanged: (value) => setState(() {
                        _editaContato.email = value;
                      }),
                      decoration: InputDecoration(hintText: "email"),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      db
                          .deleteContato(_editaContato.id)
                          .then((value) => Navigator.pop(context));
                    },
                    color: Colors.red,
                    child: Text(
                      "Excluir",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          editando
              ? db.updateContato(_editaContato)
              : db
                  .insertContato(_editaContato)
                  .then((value) => print(_editaContato))
        },
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
