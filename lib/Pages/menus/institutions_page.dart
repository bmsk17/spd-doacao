import 'package:flutter/material.dart';

class InstitutionsPage extends StatefulWidget {
  const InstitutionsPage({super.key});

  @override
  State<InstitutionsPage> createState() => _InstitutionsPageState();
}

class _InstitutionsPageState extends State<InstitutionsPage> {
  int? value = 0;

  List items = [];
  List allItems = [
    {
      'nome': 'GAIC',
      'descricao': 'Grupo de Apoio a Instituições de Caridade',
      'imageUrl': ''
    },
    {
      'nome': 'Abrigo Moacyr Alves',
      'descricao': 'Grupo de Apoio a Instituições de Caridade',
      'imageUrl': ''
    },
    {
      'nome': 'GAIC',
      'descricao': 'Grupo de Apoio a Instituições de Caridade',
      'imageUrl': ''
    },
    {
      'nome': 'GAIC',
      'descricao': 'Grupo de Apoio a Instituições de Caridade',
      'imageUrl': ''
    },
    {
      'nome': 'GAIC',
      'descricao': 'Grupo de Apoio a Instituições de Caridade',
      'imageUrl': ''
    },
  ];

  void filterSearchResults(String query) {
    setState(() {
      if (query.isEmpty) {
        items = allItems;
        return;
      }

      items = allItems
          .where((item) =>
              item['nome'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    items = allItems;
    super.initState();
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
                hintText: 'Procure por instituições ou beneficiários',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                )),
            controller: searchController,
            onChanged: (value) {
              filterSearchResults(searchController.text);
            },
          ),
          const SizedBox(height: 12),
          Wrap(spacing: 5.0, children: [
            ChoiceChip(
              label: const Text('Instituições'),
              selected: value == 0,
              onSelected: (bool selected) {
                setState(() {
                  value = 0;
                });
              },
            ),
            ChoiceChip(
              label: const Text('Beneficiários'),
              selected: value == 1,
              onSelected: (bool selected) {
                setState(() {
                  value = 1;
                });
              },
            )
          ]),
          Expanded(
            child: items.isEmpty
                ? const Center(child: Text('Sem resultados'))
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, index) => Column(
                          children: [
                            ListTile(
                              tileColor: Theme.of(context).primaryColor,
                              leading: const Icon(Icons.group),
                              title: Text(
                                items[index]['nome'],
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(items[index]['descricao']),
                            ),
                            const SizedBox(
                              height: 8,
                            )
                          ],
                        )),
          )
        ],
      ),
    );
  }
}
