import 'package:flutter/material.dart';
import 'package:flutter_maps/Pages/menus/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_maps/servicos/autenticacao_servico.dart';
import 'firebase_options.dart';
import 'package:flutter_maps/Pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AutenticacaoServico(context).getLoggerUser();
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: const Color(0xFF9BE7E2)),
        home: user != null ? Home(user) : LoginPage());
  }
}
