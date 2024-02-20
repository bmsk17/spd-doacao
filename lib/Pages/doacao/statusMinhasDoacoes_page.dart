import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_maps/Models/doacao_model.dart';

class StatusMinhasDoacoesPage extends StatelessWidget {
  final DoacaoModel doacao;
  final String idDocumento;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  StatusMinhasDoacoesPage({required this.doacao, required this.idDocumento});

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

  void _ignorarDoacao(BuildContext context) {
    // Implemente a lógica para ignorar a doação
    print('Doação ignorada!');
    Navigator.pop(context);
  }

  void _concluirDoacao(BuildContext context) {
    // Implemente a lógica para concluir a doação
    print('Doação concluída!');
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
