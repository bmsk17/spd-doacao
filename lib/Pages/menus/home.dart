import 'package:flutter/material.dart';
import 'package:flutter_maps/Models/usuario_model.dart';
import 'package:flutter_maps/Pages/doacao/doacoes_page.dart';
import 'package:flutter_maps/Pages/login_page.dart';
import 'package:flutter_maps/Pages/menus/home_page.dart';
import 'package:flutter_maps/Pages/menus/institutions_page.dart';
import 'package:flutter_maps/Pages/menus/map_page.dart';
import 'package:flutter_maps/Pages/menus/profile_page.dart';
import 'package:flutter_maps/servicos/autenticacao_servico.dart';
// import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home(UserModel user, {Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    void _signOut() async {
      await AutenticacaoServico(context).signOut();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false);
    }

    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        onDestinationSelected: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.groups), label: 'Instituições'),
          NavigationDestination(
            icon: Icon(Icons.volunteer_activism),
            label: 'Doações',
          ),
          NavigationDestination(icon: Icon(Icons.pin_drop), label: 'Mapa'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: <Widget>[
            HomePage(),
            const InstitutionsPage(),
            DoacoesPage(),
            const MapPage(),
            const ProfilePage(),
          ][currentPageIndex],
        ),
      ),
    );
  }
}
