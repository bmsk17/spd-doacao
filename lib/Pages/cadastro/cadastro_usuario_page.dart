import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_maps/Pages/menus/home.dart';
import 'package:flutter_maps/Models/usuario_model.dart';
import 'package:flutter_maps/servicos/autenticacao_servico.dart';

class CadastroPage extends StatefulWidget {
  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  File? _avatar;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  var _isLoading = false;

  void _navigateToHome(UserModel user) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Home(user)));
  }

  void _uploadImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      setState(() {
        _avatar = File(result.files.first.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Cadastro de Usuário',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Botão para buscar foto
            ElevatedButton(
              onPressed: _uploadImage,
              child: Text('Buscar Foto'),
            ),
            SizedBox(height: 12.0),
            // Exibição da foto selecionada
            _avatar != null
                ? Image.file(
                    _avatar!,
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                  )
                : Container(),
            SizedBox(height: 12.0),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nome',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Senha',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                // Perform registration logic here
                String nome = _nameController.text;
                String email = _emailController.text;
                String senha = _passwordController.text;

                // For demo purposes, just print the values
                print('Nome: $nome');
                print('Email: $email');
                print('Senha: $senha');

                setState(() => _isLoading = true);

                final user = await AutenticacaoServico(context)
                    .createUserWithEmailAndPassword(
                        nome, email, senha, _avatar, "");

                setState(() => _isLoading = false);

                if (user != null) {
                  _navigateToHome(user);
                }
                // Voltar para a tela de login
                //Navigator.pop(context);
              },
              child: Text(
                'Salvar',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 15.0),
                primary: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
