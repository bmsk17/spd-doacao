import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MinhasDoacoesPage extends StatefulWidget {
  @override
  _MinhasDoacoesPageState createState() => _MinhasDoacoesPageState();
}

class _MinhasDoacoesPageState extends State<MinhasDoacoesPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User _user;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas Doações'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('doacao')
            .where('email_doador', isEqualTo: _user.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final doacoes = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            bool emAndamento = data['status'] == 'EM ANDAMENTO';
            return Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                title: Text(
                  data['descricao'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Text('Doador: ${data['email_doador']}'),
                    Text('Receptor: ${data['email_receptor']}'),
                    Text('Status: ${data['status']}'),
                  ],
                ),
                leading: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(data['imageUrl'] ?? ''),
                    ),
                  ),
                ),
                trailing: emAndamento
                    ? ElevatedButton(
                        onPressed: () {
                          // Ação a ser realizada quando o botão for pressionado
                          print('Botão "Verificar" pressionado!');
                        },
                        child: Text('Verificar'),
                      )
                    : ElevatedButton(
                        onPressed: null,
                        child: Text('Verificar'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors
                              .grey, // Cor de fundo cinza quando desativado
                        ),
                      ),
              ),
            );
          }).toList();

          if (doacoes.isEmpty) {
            return Center(
              child: Text('Você ainda não realizou nenhuma doação.'),
            );
          }

          return ListView(
            children: doacoes,
          );
        },
      ),
    );
  }
}
