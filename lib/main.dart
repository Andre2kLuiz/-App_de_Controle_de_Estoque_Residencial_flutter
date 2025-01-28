import 'package:controle_de_estoque_residencial/models/produto.dart';
import 'package:controle_de_estoque_residencial/ui/pages/GerarListaComprasPage.dart';
import 'package:controle_de_estoque_residencial/ui/pages/cadastro_usuario_page.dart';
import 'package:controle_de_estoque_residencial/ui/pages/home_page.dart';
import 'package:controle_de_estoque_residencial/ui/pages/login_page.dart';
import 'package:controle_de_estoque_residencial/ui/pages/adicionar_produto_page.dart';
import 'package:controle_de_estoque_residencial/ui/pages/editar_produto_page.dart'; // Corrija a importação
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:controle_de_estoque_residencial/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        initialRoute: '/',
        routes: {
          '/': (context) => LoginPage(),
          '/home': (context) => MyHomePage(),
          '/cadastro_usuario': (context) => CadastroUsuarioPage(),
          '/adicionar_produto': (context) => AdicionarProdutoPage(),
          '/gerar_lista_compras': (context) => GerarListaComprasPage(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/editar_produto') {
            final produto = settings.arguments as Produto;
            return MaterialPageRoute(
              builder: (context) {
                return EditarProdutoPage(produto: produto);
              },
            );
          }
          return null;
        },
      ),
    );
  }
}
