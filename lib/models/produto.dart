class Produto {
  final String id;
  final String nome;
  final String descricao;
  final String categoria;
  final String quantidade;
  final String preco;
  final String dataCriacao; // Adicione o campo data de criação
  final int diasValidade; // Adicione o campo dias de validade
  final String userId;

  Produto({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.categoria,
    required this.quantidade,
    required this.preco,
    required this.dataCriacao, // Adicione o campo data de criação
    required this.diasValidade, // Adicione o campo dias de validade
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'categoria': categoria,
      'quantidade': quantidade,
      'preco': preco,
      'dataCriacao': dataCriacao, // Adicione o campo data de criação
      'diasValidade': diasValidade, // Adicione o campo dias de validade
      'userId': userId,
    };
  }

  factory Produto.fromMap(Map<String, dynamic> map) {
    return Produto(
      id: map['id'],
      nome: map['nome'],
      descricao: map['descricao'],
      categoria: map['categoria'],
      quantidade: map['quantidade'],
      preco: map['preco'],
      dataCriacao: map['dataCriacao'], // Adicione o campo data de criação
      diasValidade: map['diasValidade'], // Adicione o campo dias de validade
      userId: map['userId'],
    );
  }
}
