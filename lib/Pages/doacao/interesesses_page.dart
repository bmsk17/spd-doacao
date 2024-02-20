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

  Future<void> _concluirInteresse(
      BuildContext context, String idDoa, String idDocumento) async {
    // Variável para armazenar o código fornecido pelo usuário
    TextEditingController codigoController = TextEditingController();

    // Cálculo do código esperado
    int codigoEsperado = int.tryParse(idDoa) ?? -1 + 1000;
    codigoEsperado = codigoEsperado + 1000;
    // Mostrar o diálogo para inserção do código
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Informe o Código Fornecido pelo Doador'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Removido a exibição do código esperado
              // Text('Código Esperado: $codigoEsperado'),
              SizedBox(height: 12),
              TextField(
                controller: codigoController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Código',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fechar o diálogo
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                // Verificar se o código fornecido está correto
                int codigoInformado = int.tryParse(codigoController.text) ?? -1;

                if (codigoInformado == codigoEsperado) {
                  // Código correto, atualizar o status da doação para CONCLUÍDO
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
                } else {
                  // Código incorreto, exibir mensagem de erro
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Código inválido. Tente novamente.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }

                Navigator.of(context).pop(); // Fechar o diálogo
              },
              child: Text('Confirmar'),
            ),
          ],
        );
      },
    );
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
                        _concluirInteresse(context, data['id_doacao'], doc.id);
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
