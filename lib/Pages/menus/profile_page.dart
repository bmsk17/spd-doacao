import 'package:flutter/material.dart';
import 'package:flutter_maps/servicos/autenticacao_servico.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key});

  @override
  Widget build(BuildContext context) {
    final user = AutenticacaoServico(context).getLoggerUser();

    String? email = user?.email ?? 'Email não disponível';
    String? nome = user?.nome ?? 'Nome não disponível';

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nome do usuário:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          nome,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 16), // Adicionando um espaçamento entre os widgets
        Text(
          'Email do usuário:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          email,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
