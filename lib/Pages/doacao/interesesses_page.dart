import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_maps/Models/doacao_model.dart';

class InteressesPage extends StatefulWidget {
  @override
  _InteressesPageState createState() => _InteressesPageState();
}

class _InteressesPageState extends State<InteressesPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User _user;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
  }

  Future<void> _concluirInteresse(String idDocumento) async {
    try {
      await FirebaseFirestore.instance
          .collection('doacao')
          .doc(idDocumento)
          .update({
        'status': 'CONCLUÍDO',
      });
      print('Interesse concluído com sucesso!');
    } catch (e) {
      print('Erro ao concluir o interesse: $e');
    }
  }

  Future<void> _excluirInteresse(String idDocumento) async {
    try {
      await FirebaseFirestore.instance
          .collection('doacao')
          .doc(idDocumento)
          .delete();
      print('Interesse excluído com sucesso!');
    } catch (e) {
      print('Erro ao excluir o interesse: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Interesses'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('doacao')
            .where('email_receptor', isEqualTo: _user.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final interesses = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            // Criando uma instância de DoacaoModel e preenchendo-a com os dados
            DoacaoModel doacao = DoacaoModel(
              idDoacao: data['id_doacao'].toString(),
              descricao: data['descricao'],
              endereco: data['endereco'],
              emailDoador: data['email_doador'],
              emailReceptor: data['email_receptor'],
              imageUrl: data['imagemUrl'],
              status: data['status'],
              // Você pode adicionar mais campos conforme necessário
            );
            return Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ), // Aumentando o espaço vertical
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['descricao'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('Doador: ${data['email_doador']}'),
                    Text('Receptor: ${data['email_receptor']}'),
                    Text('Status: ${data['status']}'),
                  ],
                ),
                leading: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(data['imageUrl'] ?? ''),
                    ),
                  ),
                ),
                trailing: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _concluirInteresse(doc.id);
                      },
                      child: Text('Concluir'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _excluirInteresse(doc.id);
                      },
                      child: Text('Excluir'),
                    ),
                  ],
                ),
              ),
            );
          }).toList();

          if (interesses.isEmpty) {
            return Center(
              child:
                  Text('Não há interesses registrados para você no momento.'),
            );
          }

          return ListView(
            children: interesses,
          );
        },
      ),
    );
  }
}
