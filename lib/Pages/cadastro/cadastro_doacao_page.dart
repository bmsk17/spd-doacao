import 'package:flutter/material.dart';
import 'package:flutter_maps/Models/doacao_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_maps/Models/instituicao_model.dart';
import 'package:flutter_maps/servicos/autenticacao_servico.dart';

class CadastroDoacao extends StatefulWidget {
  @override
  _CadastroDoacaoState createState() => _CadastroDoacaoState();
}

class _CadastroDoacaoState extends State<CadastroDoacao> {
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _imagemController = TextEditingController();

  final db = FirebaseFirestore.instance;

  Future<int> _getLastDoacaoId() async {
    int lastId = 0;

    QuerySnapshot querySnapshot = await db
        .collection('doacao')
        .orderBy('id_doacao', descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Convertendo o ID do documento para um inteiro
      lastId = int.parse(querySnapshot.docs.first['id_doacao'] ?? '0');
    }

    return lastId;
  }

  Future<void> _salvarDoacao() async {
    int lastId = await _getLastDoacaoId();
    int novoId = lastId + 1;
    final user = AutenticacaoServico(context).getLoggerUser();
    String? email = user?.email ?? 'Email não disponível';

    var doacao = DoacaoModel(
      // Convertendo o novo ID de volta para uma string
      idDoacao: novoId.toString(),
      descricao: _descricaoController.text,
      endereco: _enderecoController.text,
      emailDoador: email,
      emailReceptor: "",
      imageUrl: _imagemController.text,
      status: "ABERTO",
    );

    await db.collection("doacao").add(doacao.toJson());

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Doação'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: _descricaoController,
              decoration: InputDecoration(
                labelText: 'Descrição',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _enderecoController,
              decoration: InputDecoration(
                labelText: 'Endereço',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _imagemController,
              decoration: InputDecoration(
                labelText: 'URL da Imagem',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                await _salvarDoacao();
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: Text(
                'Salvar',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    _enderecoController.dispose();
    _imagemController.dispose();
    super.dispose();
  }
}
