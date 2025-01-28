import 'package:flutter/material.dart';
import 'package:controle_de_estoque_residencial/models/produto.dart';
import 'package:controle_de_estoque_residencial/services/produto_service.dart';

class EditarProdutoPage extends StatefulWidget {
  final Produto produto;

  const EditarProdutoPage({super.key, required this.produto});

  @override
  State<EditarProdutoPage> createState() => _EditarProdutoPageState();
}

class _EditarProdutoPageState extends State<EditarProdutoPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nomeController;
  late TextEditingController descricaoController;
  late TextEditingController categoriaController;
  late TextEditingController quantidadeController;
  late TextEditingController precoController;
  late TextEditingController
      diasValidadeController; // Adicione o controller para dias de validade

  @override
  void initState() {
    super.initState();
    nomeController = TextEditingController(text: widget.produto.nome);
    descricaoController = TextEditingController(text: widget.produto.descricao);
    categoriaController = TextEditingController(text: widget.produto.categoria);
    quantidadeController =
        TextEditingController(text: widget.produto.quantidade);
    precoController = TextEditingController(text: widget.produto.preco);
    diasValidadeController = TextEditingController(
        text: widget.produto.diasValidade
            .toString()); // Adicione o campo dias de validade
  }

  void _editarProduto() async {
    if (_formKey.currentState!.validate()) {
      Produto produtoEditado = Produto(
        id: widget.produto.id,
        nome: nomeController.text,
        descricao: descricaoController.text,
        categoria: categoriaController.text,
        quantidade: quantidadeController.text,
        preco: precoController.text,
        dataCriacao:
            widget.produto.dataCriacao, // Mantenha a data de criação original
        diasValidade: int.parse(
            diasValidadeController.text), // Adicione o campo dias de validade
        userId: widget.produto.userId,
      );

      await updateProduto(produtoEditado);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Produto editado com sucesso!')),
      );

      Navigator.pop(context);
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
        title: Text('Editar Produto'),
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
                onPressed: _editarProduto,
                child: Text('Editar Produto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
