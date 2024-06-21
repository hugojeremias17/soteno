import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CanalizadoresPage extends StatefulWidget {
  @override
  _CanalizadoresPageState createState() => _CanalizadoresPageState();
}

class _CanalizadoresPageState extends State<CanalizadoresPage> {
  // Referência ao Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String searchQuery = '';
  String searchField = 'username';

  Stream<QuerySnapshot<Map<String, dynamic>>> _getFilteredTecnicos(String query, String field) {
    // Referência à coleção 'tecnico'
    CollectionReference<Map<String, dynamic>> tecnicosRef = _firestore.collection('tecnico');

    if (query.isEmpty) {
      // Retorna todos os documentos se a query estiver vazia
      return tecnicosRef.snapshots();
    } else {
      // Filtra os documentos com base no campo selecionado
      return tecnicosRef
          .where(field, isGreaterThanOrEqualTo: query)
          .where(field, isLessThanOrEqualTo: query + '\uf8ff')
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Canalizadores'),
      ),
      body: Column(
        children: [
          // Adicione aqui a imagem e o texto acima do ListView
          Container(
            height: 110,
            child: Image.asset('images/logo1.png'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Dropdown para selecionar o campo de pesquisa
                Row(
                  children: [
                    Expanded(
                      child: DropdownButton<String>(
                        value: searchField,
                        items: [
                          DropdownMenuItem(
                            value: 'username',
                            child: Text('Username'),
                          ),
                          DropdownMenuItem(
                            value: 'Funcao',
                            child: Text('Função'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            searchField = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                // Barra de pesquisa
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Pesquisar',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _getFilteredTecnicos(searchQuery, searchField),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro ao carregar os dados'));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('Nenhum canalizador encontrado.'));
                } else {
                  List<QueryDocumentSnapshot<Map<String, dynamic>>> canalizadores = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: canalizadores.length,
                    itemBuilder: (context, index) {
                      // Dados do canalizador
                      Map<String, dynamic> canalizadorData = canalizadores[index].data();

                      // Exibir os detalhes do canalizador (por exemplo, o nome)
                      return Column(
                        children: [
                          Card(
                            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            child: Container(
                              width: 400,
                              child: Center(
                                child: Row(
                                  children: [
                                    Container(
                                      height: 100,
                                      width: 90,
                                      child: CircleAvatar(),
                                    ),
                                    SizedBox(width: 5),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          canalizadorData['username'] ?? '',
                                          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          canalizadorData['Funcao'] ?? '',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        Text(
                                          canalizadorData['idade'] ?? '',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

