import 'package:flutter/material.dart';
import 'package:controle_de_estoque_residencial/models/produto.dart';
import 'package:controle_de_estoque_residencial/services/produto_service.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importe o FirebaseAuth
import 'package:intl/intl.dart'; // Importe o pacote intl para formatação de datas

class AdicionarProdutoPage extends StatefulWidget {
  const AdicionarProdutoPage({super.key});

  @override
  State<AdicionarProdutoPage> createState() => _AdicionarProdutoPageState();
}

class _AdicionarProdutoPageState extends State<AdicionarProdutoPage> {
  final _formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final descricaoController = TextEditingController();
  final categoriaController = TextEditingController();
  final quantidadeController = TextEditingController();
  final precoController = TextEditingController();
  final diasValidadeController =
      TextEditingController(); // Adicione o controller para dias de validade

  void _adicionarProduto() async {
    if (_formKey.currentState!.validate()) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String dataCriacao = DateFormat('dd/MM/yyyy').format(DateTime.now());
        int diasValidade = int.parse(diasValidadeController.text);
        Produto novoProduto = Produto(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          nome: nomeController.text,
          descricao: descricaoController.text,
          categoria: categoriaController.text,
          quantidade: quantidadeController.text,
          preco: precoController.text,
          dataCriacao: dataCriacao, // Adicione o campo data de criação
          diasValidade: diasValidade, // Adicione o campo dias de validade
          userId: user.uid,
        );

        await setProduto(novoProduto);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Produto adicionado com sucesso!')),
        );

        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    nomeController.dispose();
    descricaoController.dispose();
    categoriaController.dispose();
    quantidadeController.dispose();
    precoController.dispose();
    diasValidadeController
        .dispose(); // Adicione o dispose para dias de validade
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do produto';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: descricaoController,
                decoration: InputDecoration(labelText: 'Descrição'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a descrição do produto';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: categoriaController,
                decoration: InputDecoration(labelText: 'Categoria'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a categoria do produto';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: quantidadeController,
                decoration: InputDecoration(labelText: 'Quantidade'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a quantidade do produto';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: precoController,
                decoration: InputDecoration(labelText: 'Preço'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o preço do produto';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller:
                    diasValidadeController, // Adicione o campo dias de validade
                decoration: InputDecoration(labelText: 'Dias de Validade'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a quantidade de dias de validade';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _adicionarProduto,
                child: Text('Adicionar Produto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
