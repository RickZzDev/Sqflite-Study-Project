class Contact {
  int id;
  String nome;
  String email;

  Contact(this.id, this.nome, this.email);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{"id": id, "nome": nome, "email": email};
    return map;
  }

  Contact.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    nome = map['nome'];
    email = map['email'];
  }
}
