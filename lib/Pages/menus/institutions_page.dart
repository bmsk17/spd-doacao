import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_maps/Models/instituicao_model.dart';

class InstitutionsPage extends StatelessWidget {
  const InstitutionsPage({Key? key});

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Barra de pesquisa
          SearchBar(
            controller: searchController,
            leading: const Icon(Icons.search),
            hintText: 'Procure por instituições ou beneficiários',
          ),
          const SizedBox(height: 12),
          // Chips de filtro
          const Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Chip(
                label: Text('Beneficiários'),
              ),
              SizedBox(width: 4),
              Chip(
                label: Text('Instituições'),
              ),
            ],
          ),
          SizedBox(
            height: 400,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('instituicao')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final documents = snapshot.data!.docs;
                List<InstituicaoModel> instituicoes = documents.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return InstituicaoModel(
                    nome: data['nome'],
                    descricao: data['descricao'],
                    endereco: data['endereco'],
                    telefone: data['telefone'],
                    longitude: (data['longitude']),
                    latitude: (data['latitude']),
                    site: data['site'],
                    imagem: data['imagem'],
                  );
                }).toList();
                return ListView.builder(
                  itemCount: instituicoes.length,
                  itemBuilder: (context, index) {
                    final instituicao = instituicoes[index];
                    return Column(
                      children: [
                        ListTile(
                          tileColor: Theme.of(context).primaryColor,
                          leading: const Icon(Icons.group),
                          title: Text(
                            instituicao.nome ?? '',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(instituicao.descricao ?? ''),
                        ),
                        const SizedBox(
                          height: 8,
                        )
                      ],
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
