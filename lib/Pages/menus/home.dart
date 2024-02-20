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
    String? _avatar = user?.avatar ?? 'Email não disponível';

    void _signOut() async {
      await AutenticacaoServico(context).signOut();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false);
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(_avatar ?? ''),
            ),
            const SizedBox(width: 8),
            Text(widget.user.nome ?? ''),
          ],
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
            const HomePage(),
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
