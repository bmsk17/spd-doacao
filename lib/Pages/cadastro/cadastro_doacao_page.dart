import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_maps/Models/doacao_model.dart';
import 'package:flutter_maps/servicos/autenticacao_servico.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart'; // Importar a biblioteca de máscara

class CadastroDoacao extends StatefulWidget {
  @override
  _CadastroDoacaoState createState() => _CadastroDoacaoState();
}

class _CadastroDoacaoState extends State<CadastroDoacao> {
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _contatoController = TextEditingController();
  File? _imagem;

  final db = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  Future<int> _getLastDoacaoId() async {
    int lastId = 0;

    QuerySnapshot querySnapshot = await db
        .collection('doacao')
        .orderBy('id_doacao', descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
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
      idDoacao: novoId.toString(),
      descricao: _descricaoController.text,
      endereco: _enderecoController.text,
      emailDoador: email,
      emailReceptor: "",
      imageUrl: "",
      status: "ABERTO",
      contato: _contatoController.text,
    );

    if (_imagem != null) {
      final storageRef =
          storage.ref().child('doacao_images').child('${DateTime.now()}.jpg');
      await storageRef.putFile(_imagem!);
      final imageUrl = await storageRef.getDownloadURL();
      doacao.imageUrl = imageUrl;
    }

    await db.collection("doacao").add(doacao.toJson());
    Navigator.pop(context);
  }

  void _uploadImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      setState(() {
        _imagem = File(result.files.first.path!);
      });
    }
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
            ElevatedButton(
              onPressed: _uploadImage,
              child: Text('Buscar Foto'),
            ),
            SizedBox(height: 12.0),
            _imagem != null
                ? Image.file(
                    _imagem!,
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                  )
                : Container(),
            SizedBox(height: 12.0),
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
              controller: _contatoController,
              inputFormatters: [
                MaskTextInputFormatter(
                  mask: '(##) #####-####', // Máscara de telefone
                  filter: {"#": RegExp(r'[0-9]')}, // Apenas números
                ),
              ],
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Contato',
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
    _contatoController.dispose();
    super.dispose();
  }
}
