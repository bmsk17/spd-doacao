import 'package:flutter/material.dart';

class InstitutionsPage extends StatelessWidget {
  const InstitutionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SearchBar(
            controller: searchController,
            leading: const Icon(Icons.search),
            hintText: 'Procure por instituições ou beneficiários',
          ),
          const SizedBox(height: 12),
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
            child: ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) => Column(
                      children: [
                        ListTile(
                          tileColor: Theme.of(context).primaryColor,
                          leading: const Icon(Icons.group),
                          title: const Text(
                            'GAIC',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          subtitle: const Text(
                              'Grupo de Apoio a Instituições de Caridade'),
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
