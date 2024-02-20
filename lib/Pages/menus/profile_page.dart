import 'package:flutter/material.dart';
import 'package:flutter_maps/servicos/autenticacao_servico.dart';
import 'package:flutter_maps/shared/profile_button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Usuário',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ProfileButton(label: 'Informações', onPressed: () {}),
        const SizedBox(height: 10),
        ProfileButton(label: 'Suas Doações', onPressed: () {}),
        const SizedBox(height: 20),
        const Text(
          'Configurações e Privacidade',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ProfileButton(label: 'Configurações', onPressed: () {}),
        const SizedBox(height: 10),
        ProfileButton(label: 'Privacidade', onPressed: () {}),
        const SizedBox(height: 10),
        ProfileButton(label: 'Sobre', onPressed: () {})
      ],
    );
  }
}
