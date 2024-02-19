import 'package:flutter/material.dart';
import 'package:flutter_maps/Models/doacao_model.dart';
import 'package:flutter_maps/Pages/cadastro/cadastro_doacao_page.dart';
import 'package:flutter_maps/Pages/doacao/doacaoInfo_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoacoesPage extends StatefulWidget {
  @override
  _DoacoesPageState createState() => _DoacoesPageState();
}

class _DoacoesPageState extends State<DoacoesPage> {
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doações Disponíveis'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: db.collection('doacao').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final doacoes = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return DoacaoModel(
              id_doacao: data['id_doacao'].toString(),
              descricao: data['descricao'],
              endereco: data['endereco'],
              imagemUrl: data['imagemUrl'],
              status: data['status'] ?? false,
            );
          }).toList();
          return ListView.builder(
            itemCount: doacoes.length,
            itemBuilder: (context, index) {
              final doacao = doacoes[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(doacao.imagemUrl ?? ''),
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
                    child: Text('Adquirir'),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CadastroDoacao()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DoacoesPage(),
  ));
}
