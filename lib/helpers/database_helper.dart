import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_project/models/myModel.dart';

class DataBaseHelper {
  static DataBaseHelper _dataBaseHelper;
  static Database _database;

  //Colunas do banco
  String contatoTable = 'contato';
  String colId = 'id';
  String colNome = 'nome';
  String colEmail = 'email';

  //Construtor nomeado para criar a instancia da classe
  DataBaseHelper._createInstace();

  factory DataBaseHelper() {
    if (_dataBaseHelper == null) {
      _dataBaseHelper = DataBaseHelper._createInstace();
    }
    return _dataBaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initDataBase();
    }
    return _database;
  }

  Future<List<Contact>> getAllContatos() async {
    Database db = await this.database;
    var resultado = await db.query(contatoTable);
    List<Contact> lista = resultado.isNotEmpty
        ? resultado.map((e) => Contact.fromMap(e)).toList()
        : [];
    return lista;
  }

  Future<Database> initDataBase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'contatos.db';

    var contatosDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return contatosDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $contatoTable($colId integer primary key autoincrement, $colNome text, $colEmail text)');
  }

  //Incluir um objeto
  Future<int> insertContato(Contact contato) async {
    Database db = await this.database;
    var resultado = db.insert(contatoTable, contato.toMap());
  }

  //Retorna contato pelo id
  Future<Contact> getContato(int id) async {
    Database db = await this.database;
    List<Map> maps = await db.query(contatoTable,
        columns: [colId, colNome, colEmail],
        where: "$colId = ?",
        whereArgs: [id]);

    if (maps.length > 0) {
      return Contact.fromMap(maps.first);
    } else {
      return null;
    }
  }

  //Atualizar contato existente
  Future<int> updateContato(Contact contato) async {
    Database db = await this.database;

    var resultado = db.update(contatoTable, contato.toMap(),
        where: '$colId = ?', whereArgs: [contato.id]);

    return resultado;
  }

  //Deleta um contato do banco
  Future<int> deleteContato(int id) async {
    Database db = await this.database;

    var resultado =
        db.delete(contatoTable, where: '$colId = ?', whereArgs: [id]);

    return resultado;
  }

  //Obtem o número de objetos contato no banco de dados
  Future<int> getCount() async {
    Database db = await this.database;

    List<Map<String, dynamic>> x =
        await db.rawQuery('select count (*) from $contatoTable');

    int resultado = Sqflite.firstIntValue(x);
    return resultado;
  }

  //Método para fechar banco de dados
  Future close() async {
    Database db = await this.database;
    db.close();
  }
}
