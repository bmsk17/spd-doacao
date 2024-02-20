import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_maps/Models/doacao_model.dart';
import 'package:flutter_maps/Pages/cadastro/cadastro_doacao_page.dart';
import 'package:flutter_maps/Pages/doacao/doacaoInfo_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_maps/Pages/doacao/minhasDoacoes_page.dart';
import 'package:flutter_maps/servicos/autenticacao_servico.dart';

class DoacoesPage extends StatefulWidget {
  @override
  _DoacoesPageState createState() => _DoacoesPageState();
}

class _DoacoesPageState extends State<DoacoesPage> {
  final db = FirebaseFirestore.instance;
  final StreamController<QuerySnapshot> _streamController =
      StreamController<QuerySnapshot>();

  @override
  void initState() {
    super.initState();
    final user = AutenticacaoServico(context).getLoggerUser();
    String? email = user?.email ?? 'Email não disponível';
    // Cria um stream do Firebase com a consulta desejada
    db
        .collection('doacao')
        .where('email_doador', isNotEqualTo: email)
        .where('status', isEqualTo: 'ABERTO')
        .snapshots()
        .listen((data) {
      _streamController.add(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doações Disponíveis'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _streamController.stream, // Usando o stream do StreamController
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final doacoes = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return DoacaoModel(
              idDoacao: data['id_doacao'].toString(),
              descricao: data['descricao'],
              endereco: data['endereco'],
              emailDoador: data['email_doador'],
              emailReceptor: data['email_receptor'],
              imageUrl: data['imagemUrl'],
              status: data['status'],
            );
          }).toList();

          return ListView.builder(
            itemCount: doacoes.length,
            itemBuilder: (context, index) {
              final doacao = doacoes[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(doacao.imageUrl ?? ''),
                  ),
                  title: Text(doacao.descricao ?? ''),
                  trailing: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InfoDoacao(
                            doacao: doacao,
                            idDocumento: snapshot.data!.docs[index].id,
                          ),
                        ),
                      );
                    },
                    child: Text('Mais Informações'),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Mostra um menu de opções ao pressionar o botão de adicionar

          
          showMenu(
            context: context,
            position: RelativeRect.fromLTRB(
                1000.0, 1000.0, 0.0, 0.0), // Posição do menu
            items: [
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.add),
                  title: Text('Cadastro de Doações'),
                  onTap: () {
                    Navigator.pop(context); // Fecha o menu
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CadastroDoacao()),
                    );
                  },
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.list),
                  title: Text('Minhas Doações'),
                  onTap: () {
                    Navigator.pop(context); // Fecha o menu
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MinhasDoacoesPage()),
                    );
                  },
                ),
              ),
            ],
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _streamController
        .close(); // Fechar o StreamController quando não for mais necessário
    super.dispose();
  }
}

void main() {
  runApp(MaterialApp(
    home: DoacoesPage(),
  ));
}
