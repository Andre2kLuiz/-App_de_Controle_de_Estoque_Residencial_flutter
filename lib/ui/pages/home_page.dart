import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:controle_de_estoque_residencial/services/produto_service.dart';
import 'package:controle_de_estoque_residencial/models/produto.dart';
import 'package:controle_de_estoque_residencial/ui/widgets/produto_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // Importe o pacote intl para formatação de datas

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = true;
  List<Produto> _produtos = [];
  late FirebaseMessaging _firebaseMessaging;

  @override
  void initState() {
    super.initState();
    _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      if (notification != null) {
        _mostrarAlertaNotificacao(notification.title, notification.body);
      }
    });
    _loadProdutos();
  }

  Future<void> _loadProdutos() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      List<Produto> produtos = await getProdutos(user.uid);
      setState(() {
        _produtos = produtos;
        _isLoading = false;
      });
      _verificarProdutosProximosAoVencimento(produtos);
    }
  }

  Future<void> _verificarProdutosProximosAoVencimento(
      List<Produto> produtos) async {
    DateTime hoje = DateTime.now();
    for (var produto in produtos) {
      // Calcula a data de validade
      DateTime dataCriacao =
          DateFormat('dd/MM/yyyy').parse(produto.dataCriacao);
      DateTime dataValidade =
          dataCriacao.add(Duration(days: produto.diasValidade));

      // Verifica se o produto está próximo ao vencimento
      if (dataValidade.difference(hoje).inDays <= 2) {
        _mostrarAlertaNotificacao(
          'Produto próximo ao vencimento',
          'O produto ${produto.nome} está próximo ao vencimento.',
        );
      }
    }
  }

  void _mostrarAlertaNotificacao(String? titulo, String? mensagem) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(titulo ?? 'Notificação'),
        content: Text(mensagem ?? 'Você tem uma nova notificação.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _excluirProduto(String id) async {
    await deleteProduto(id);
    _loadProdutos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produtos Cadastrados'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _produtos.isNotEmpty
              ? ListView.builder(
                  itemCount: _produtos.length,
                  itemBuilder: (context, index) {
                    Produto produto = _produtos[index];
                    return Dismissible(
                      key: Key(produto.id),
                      direction: DismissDirection.startToEnd,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      confirmDismiss: (direction) async {
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Excluir Produto'),
                              content: Text(
                                  'Deseja excluir o produto ${produto.nome}?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: Text('Excluir'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      onDismissed: (direction) {
                        _excluirProduto(produto.id);
                      },
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/editar_produto',
                            arguments: produto,
                          ).then((_) {
                            _loadProdutos(); // Atualize a lista de produtos após a edição
                          });
                        },
                        child: ProdutoCard(produto: produto),
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(
                    'Nenhum produto cadastrado',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              await Navigator.pushNamed(context, '/adicionar_produto');
              _loadProdutos(); // Atualize a lista de produtos após adicionar um novo produto
            },
            child: Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/gerar_lista_compras');
            },
            child: Icon(Icons.shopping_cart),
          ),
        ],
      ),
    );
  }
}
