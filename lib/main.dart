import 'package:flutter/material.dart';
import 'package:sqflite_project/helpers/database_helper.dart';
import 'package:sqflite_project/models/myModel.dart';
import 'package:sqflite_project/pages/contact_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DataBaseHelper db = DataBaseHelper();

  List<Contact> contatos = List<Contact>();

  @override
  void initState() {
    super.initState();
    db.getAllContatos().then((value) => {
          setState(() {
            contatos = value;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: contatos.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return ContactPage(
                    contato: contatos[index],
                  );
                },
              ),
            ),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(10.00),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          contatos[index].nome ?? "",
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          contatos[index].email ?? "",
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ContactPage();
            },
          ),
        ),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
