import 'package:flutter/material.dart';
import 'package:flutter_maps/Models/usuario_model.dart';
import 'package:flutter_maps/Pages/menus/home.dart';
import 'package:flutter_maps/servicos/autenticacao_servico.dart';
import 'cadastro/cadastro_usuario_page.dart'; // Importando a página de cadastro

void main() {
  runApp(LoginApp());
}

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _signInWithEmailAndPasswordLoading = false;

  String _errorMessage = '';

  void _navigateToHome(UserModel user) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Home(user)));
  }

  void _resetForm() {
    _usernameController.clear();
    _passwordController.clear();
  }

  void _signInEmailAndPassword() async {
    final email = _usernameController.text;
    final senha = _passwordController.text;

    setState(() => _signInWithEmailAndPasswordLoading = true);

    final user = await AutenticacaoServico(context)
        .signInWithEmailAndPassword(senha, email);

    setState(() => _signInWithEmailAndPasswordLoading = false);

    if (user != null) {
      _resetForm();
      _navigateToHome(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Login',
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
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.person),
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
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              _errorMessage,
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _signInEmailAndPassword();
                    },
                    icon: Icon(Icons.login),
                    label: Text('Login'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.0),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {
                      // Navigate to registration page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CadastroPage()),
                      );
                    },
                    icon: Icon(Icons.person_add),
                    label: Text('Cadastrar'),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
