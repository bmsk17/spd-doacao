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
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
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
                'id: ${doacao.idDoacao}',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () => _adquirirDoacao(context),
                child: Text('Interessado em Adquirir'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
