import 'package:controle_de_estoque_residencial/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Importe o serviço de usuário
import 'package:controle_de_estoque_residencial/models/usuario.dart'; // Importe o modelo de usuário

class CadastroUsuarioPage extends StatefulWidget {
  const CadastroUsuarioPage({super.key, this.onTap});

  final void Function()? onTap;

  @override
  State<CadastroUsuarioPage> createState() => _CadastroUsuarioPageState();
}

class _CadastroUsuarioPageState extends State<CadastroUsuarioPage> {
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String? errorMessage;

  void signUp() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        errorMessage = 'As senhas não coincidem.';
      });
      return;
    }

    try {
      Usuario usuario = await authService.signUpWithEmailAndPassword(
        emailController.value.text,
        passwordController.value.text,
        nomeController.value.text,
      );
      print('Cadastro bem-sucedido: ${usuario.email}');

      // Navegar para a LoginPage após cadastro bem-sucedido
      Navigator.pushReplacementNamed(context, '/');
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
      print('Erro de cadastro: ${e.message}');
    } catch (e) {
      setState(() {
        errorMessage = 'Ocorreu um erro inesperado. Tente novamente.';
      });
      print('Erro inesperado: $e');
    }
  }

  String? validateNome(String nome) {
    if (nome.isEmpty) {
      return 'Por favor, insira um nome.';
    }
    return null;
  }

  String? validateEmail(String email) {
    if (email.isEmpty) {
      return 'Por favor, insira um email.';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(email)) {
      return 'Por favor, insira um email válido.';
    }
    return null;
  }

  String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Por favor, insira uma senha.';
    }
    if (password.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres.';
    }
    return null;
  }

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person_add,
                size: 100,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 50),
              Text(
                'Cadastro de Usuário',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                  errorText: validateNome(nomeController.value.text),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  errorText: validateEmail(emailController.value.text),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                  errorText: validatePassword(passwordController.value.text),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirmar Senha',
                  border: OutlineInputBorder(),
                  errorText:
                      validatePassword(confirmPasswordController.value.text),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    errorMessage = null;
                  });
                  final nomeError = validateNome(nomeController.value.text);
                  final emailError = validateEmail(emailController.value.text);
                  final passwordError =
                      validatePassword(passwordController.value.text);
                  final confirmPasswordError =
                      validatePassword(confirmPasswordController.value.text);
                  if (nomeError == null &&
                      emailError == null &&
                      passwordError == null &&
                      confirmPasswordError == null) {
                    signUp();
                  } else {
                    setState(() {
                      errorMessage = nomeError ??
                          emailError ??
                          passwordError ??
                          confirmPasswordError;
                    });
                  }
                },
                child: const Text('Cadastrar'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Já tem uma conta?',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      'Entrar agora.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
