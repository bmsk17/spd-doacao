import 'package:flutter/material.dart';
import 'package:flutter_maps/servicos/autenticacao_servico.dart';
import 'package:flutter_maps/shared/profile_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        ProfileButton(
          label: 'Informações',
          onPressed: () {
            // Função para exibir as informações do usuário em um pop-up
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Informações do Usuário'),
                  content: FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('usuario')
                        .doc(
                            AutenticacaoServico(context).getLoggerUser()?.email)
                        .get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Erro: ${snapshot.error}');
                      }
                      final data = snapshot.data!.data();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                              'Nome: ${AutenticacaoServico(context).getLoggerUser()?.nome ?? 'Nome não disponível'}'),
                          Text(
                              'Email: ${AutenticacaoServico(context).getLoggerUser()?.email ?? 'Email não disponível'}'),
                          Text(
                              'Telefone: ${(data as Map<String, dynamic>?)?['telefonePessoal'] ?? 'Telefone não disponível'}'),
                        ],
                      );
                    },
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Fechar'),
                    ),
                  ],
                );
              },
            );
          },
        ),
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
