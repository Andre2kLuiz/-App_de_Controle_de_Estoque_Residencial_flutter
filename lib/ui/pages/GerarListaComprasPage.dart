import 'package:flutter/material.dart';
import 'package:controle_de_estoque_residencial/services/produto_service.dart';
import 'package:controle_de_estoque_residencial/models/produto.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GerarListaComprasPage extends StatefulWidget {
  const GerarListaComprasPage({super.key});

  @override
  State<GerarListaComprasPage> createState() => _GerarListaComprasPageState();
}

class _GerarListaComprasPageState extends State<GerarListaComprasPage> {
  bool _isLoading = true;
  List<Produto> _produtosEmFalta = [];

  @override
  void initState() {
    super.initState();
    _loadProdutosEmFalta();
  }

  Future<void> _loadProdutosEmFalta() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      List<Produto> produtos = await getProdutos(user.uid);
      setState(() {
        _produtosEmFalta = produtos
            .where((produto) => int.parse(produto.quantidade) <= 2)
            .toList();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Compras'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _produtosEmFalta.isNotEmpty
              ? ListView.builder(
                  itemCount: _produtosEmFalta.length,
                  itemBuilder: (context, index) {
                    Produto produto = _produtosEmFalta[index];
                    return ListTile(
                      title: Text(produto.nome),
                      subtitle: Text('Quantidade: ${produto.quantidade}'),
                    );
                  },
                )
              : Center(
                  child: Text(
                    'Nenhum item em falta',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ),
    );
  }
}
