import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class EmpregadasPage extends StatefulWidget {
  @override
  _EmpregadasPageState createState() => _EmpregadasPageState();
}

class _EmpregadasPageState extends State<EmpregadasPage> {
  // Referência ao Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método para obter os canalizadores da subcoleção
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> _getCanalizadores() async {
    try {
      // Referência ao documento 'document_canalizadores' na coleção 'tecnicos'
      CollectionReference tecnicoRef = _firestore.collection('tecnico');
      DocumentSnapshot document = await tecnicoRef.doc('document_empregadas').get();

      // Obter a subcoleção 'canalizadores' do documento 'document_canalizadores'
      QuerySnapshot empregadasSnapshot = await document.reference.collection('empregadas').get();

      // Converter os documentos para o tipo correto
      List<QueryDocumentSnapshot<Map<String, dynamic>>> empregadas = empregadasSnapshot.docs
          .map((doc) => doc as QueryDocumentSnapshot<Map<String, dynamic>>)
          .toList();
      print(empregadas);

      return empregadas;
    } catch (e) {
      print('Erro ao buscar canalizadores: $e');
      return []; // Retornar uma lista vazia em caso de erro
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Empregadas'),
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
        future: _getCanalizadores(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar os dados'));
          } else {
            List<QueryDocumentSnapshot<Map<String, dynamic>>> empregadas = snapshot.data ?? [];

            if (empregadas.isEmpty) {
              return Center(child: Text('Nenhum empregada(o) encontrado.'));
            }

            return ListView.builder(
                itemCount: empregadas.length,
                itemBuilder: (context, index) {
                  // Dados do canalizador
                  Map<String, dynamic> empregadasData = empregadas[index].data();

                  // Exibir os detalhes do canalizador (por exemplo, o nome)
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(

                      title: Text(empregadasData['username'] ?? ''),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Idade: ${empregadasData['idade'] ?? ''}'),
                          Text('Endereço: ${empregadasData['endereco'] ?? ''}'),
                          Text('Descrição: ${empregadasData['descricao'] ?? ''}'),
                        ],
                      ),
                      // Adicione mais campos conforme necessário
                    ),
                  );
                }
            );
          }
        },
      ),
    );
  }
}
