import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_maps/Models/instituicao_model.dart';

class InstitutionsPage extends StatefulWidget {
  const InstitutionsPage({Key? key}) : super(key: key);

  @override
  State<InstitutionsPage> createState() => _InstitutionsPageState();
}

class _InstitutionsPageState extends State<InstitutionsPage> {
  late List<InstituicaoModel> items;
  late List<InstituicaoModel> allItems;

  @override
  void initState() {
    super.initState();
    // Inicializando as listas vazias
    items = [];
    allItems = [];
    // Chamando a função para carregar os dados do Firestore
    _loadInstituicoes();
  }

  Future<void> _loadInstituicoes() async {
    // Acessando a coleção 'instituicao' no Firestore
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('instituicao').get();

    setState(() {
      // Iterando sobre os documentos obtidos
      allItems = querySnapshot.docs
          .map((doc) => InstituicaoModel.fromJson(doc.data()!))
          .toList();
      items =
          List<InstituicaoModel>.from(allItems); // Corrigindo o tipo da lista
    });
  }

  void filterSearchResults(String query) {
    setState(() {
      if (query.isEmpty) {
        items =
            List<InstituicaoModel>.from(allItems); // Corrigindo o tipo da lista
        return;
      }

      items = allItems
          .where((item) =>
              item.nome?.toLowerCase().contains(query.toLowerCase()) ?? false)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Procure por instituições',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
            ),
            controller: searchController,
            onChanged: (value) {
              filterSearchResults(searchController.text);
            },
          ),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (items.isEmpty)
                    const Center(child: Text('Sem resultados'))
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final instituicao = items[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: ListTile(
                            tileColor: Theme.of(context).primaryColor,
                            leading: const Icon(Icons.group),
                            title: Text(
                              instituicao.nome ?? '',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(instituicao.descricao ?? ''),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
