import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_maps/Models/doacao_model.dart';

class StatusMinhasDoacoesPage extends StatelessWidget {
  final DoacaoModel doacao;
  final String idDocumento;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  StatusMinhasDoacoesPage({required this.doacao, required this.idDocumento});

  Future<void> _concluirDoacao(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('doacao')
          .doc(idDocumento)
          .update({
        'status': "CONCLUIDO",
      });
      print('Status da doação atualizado com sucesso!');

      // Mostrar o pop-up com o código da doação + 1000
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Código para o Receptor'),
            content: Text('O código é: ${int.parse(doacao.idDoacao!) + 1000}'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fechar o diálogo
                  Navigator.pop(context); // Fechar a página atual
                },
                child: Text('Fechar'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Erro ao atualizar o status da doação: $e');
    }
  }

  void _ignorarDoacao(BuildContext context) {
    // Implemente a lógica para ignorar a doação
    print('Doação ignorada!');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da Doação'),
      ),
      body: SingleChildScrollView(
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
            Text(
              'Descrição: ${doacao.descricao}',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 12.0),
            Text(
              'Endereço: ${doacao.endereco}',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 12.0),
            Text(
              'ID: ${doacao.idDoacao}',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _ignorarDoacao(context),
                  child: Text('Ignorar'),
                ),
                ElevatedButton(
                  onPressed: () => _concluirDoacao(context),
                  child: Text('Concluído'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
