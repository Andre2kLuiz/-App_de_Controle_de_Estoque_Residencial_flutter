class Categoria {
  final String id;
  final String nome;
  final String descricao;

  Categoria({
    required this.id,
    required this.nome,
    required this.descricao,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
    };
  }

  factory Categoria.fromMap(Map<String, dynamic> map) {
    return Categoria(
      id: map['id'],
      nome: map['nome'],
      descricao: map['descricao'],
    );
  }
}
