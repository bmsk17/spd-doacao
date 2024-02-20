import 'package:flutter/material.dart';
import 'package:flutter_maps/Models/doacao_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InfoDoacao extends StatelessWidget {
  final DoacaoModel doacao;
  final String idDocumento;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  InfoDoacao({required this.doacao, required this.idDocumento});

  Future<void> _adquirirDoacao(BuildContext context) async {
    print("------------------>>>>>   : ${idDocumento}");
    try {
      await FirebaseFirestore.instance
          .collection('doacao')
          .doc(idDocumento)
          .update({
        'status': "EM ANDAMENTO",
      });
      print('Status da doação atualizado com sucesso!');
      Navigator.pop(context);
    } catch (e) {
      print('Erro ao atualizar o status da doação: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da Doação'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 200,
                height: 200,
                color: Colors.grey,
                child: doacao.imageUrl != null
                    ? Image.network(
                        doacao.imageUrl!,
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.error,
                            color: Colors.red,
                          );
                        },
                      )
                    : Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
              ),
            ),
            SizedBox(height: 24.0),
            Center(
              child: Text(
                '${doacao.descricao}',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 24.0),
            Center(
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contato: ${doacao.contato}',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(height: 12.0),
                    Text(
                      'Data de Criação: ${doacao.dataCriacao.day}/${doacao.dataCriacao.month}/${doacao.dataCriacao.year}',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.0),
            Center(
              child: ElevatedButton(
                onPressed: () => _adquirirDoacao(context),
                child: Text('Interessado em Adquirir'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
