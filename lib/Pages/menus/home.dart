// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_maps/Models/usuario_model.dart';
import 'package:flutter_maps/Pages/doacao/doacoes_page.dart';
import 'package:flutter_maps/Pages/login_page.dart';
import 'package:flutter_maps/Pages/menus/home_page.dart';
import 'package:flutter_maps/Pages/menus/institutions_page.dart';
import 'package:flutter_maps/Pages/menus/map_page.dart';
import 'package:flutter_maps/Pages/menus/profile_page.dart';
import 'package:flutter_maps/servicos/autenticacao_servico.dart';

class Home extends StatefulWidget {
  final UserModel user;

  const Home(this.user, {Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = AutenticacaoServico(context).getLoggerUser();

    String? email = user?.email ?? 'Email não disponível';
    String? nome = user?.nome ?? 'Nome não disponível';

    void signOut() async {
      await AutenticacaoServico(context).signOut();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false);
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(),
        ),
        title: Text(
          nome,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        titleSpacing: 2,
        actions: [
          IconButton(
            onPressed: () {
              signOut();
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
