import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:sotenooficial/features/app/components/text_box.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../features/app/components/text_box.dart';

class perfilEmpresa extends StatefulWidget {
  const perfilEmpresa({super.key});

  @override
  State<perfilEmpresa> createState() => _perfilEmpresaState();
}

class _perfilEmpresaState extends State<perfilEmpresa> {

  String tProfile = "Profile";
  FirebaseAuth _auth = FirebaseAuth.instance;
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection("users");
  FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Editar $field',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Adicione um novo $field',
            hintStyle: TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Salvar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (newValue.trim().length > 0) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: currentUser.email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final docRef = querySnapshot.docs.first.reference;
        await docRef.update({field: newValue});
      } else {
        print('No user found with the current email.');
      }
    }
  }




  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final emailUser = currentUser.email!;
    return Scaffold(
        appBar: AppBar(
          title: Text('Perfil'),
          backgroundColor: Colors.grey[300],
        ),

        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('users').where('email', isEqualTo: currentUser.email).snapshots(),
            builder: (context, snapshot) {
              if( snapshot.hasData){
                final userDocs = snapshot.data!.docs;
                if (userDocs.isEmpty) {
                  return Center(child: Text('No user found with this email'));
                }
                final userData = userDocs.first.data() as Map<String, dynamic>;
                return ListView(
                  children: [
                    const SizedBox(height: 50,),
                    Container(
                      width: 120,
                      height: 110,
                      child: CircleAvatar(
                        backgroundColor: Colors.orangeAccent,
                        child: Icon(Icons.person, color: Colors.white,),
                      ),
                    ),
                    SizedBox(height: 15,),
                    Text(
                      currentUser.email!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[700]
                      ),
                    ),
                    SizedBox(height: 50,),
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Text('Meus Detalhes', style: TextStyle(color: Colors.grey[600]),),
                    ),
                    MyTextBox(
                      text: userData['username'],
                      sectionName: 'Nome de Usuário',
                      onPressed: () => editField('username'),
                    ),
                    MyTextBox(
                      text: userData['role'],
                      sectionName: 'Permissão',
                      onPressed: () {},
                    ),
                    MyTextBox(
                      text: userData['nif'],
                      sectionName: 'NIF',
                      onPressed: () => editField('nif') ,
                    ),
                    SizedBox(height: 50,),
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child:  Text(
                        'Minhas Vagas', style:  TextStyle(color: Colors.grey[600]),
                      ),
                    )
                  ],
                );
              } else if(snapshot.hasError){
                return Center(
                  child: Text('Error${snapshot.error}'),
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );

            }
        )
    );
  }
}
