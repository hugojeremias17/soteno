import 'package:flutter/material.dart';
import 'package:sotenooficial/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/perfilpageEmpregador.dart';
import 'package:sotenooficial/main.dart';
import 'package:sotenooficial/global/common/toast.dart';
import 'package:sotenooficial/features/app/components/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
void main() {
  runApp(criarperfilTecnico());
}

class criarperfilTecnico extends StatelessWidget {

  criarperfilTecnico({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Tecnico(),
    );
  }
}


class Tecnico extends StatelessWidget {
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey();

  void _criarPerfil() async {
    if (_formKey.currentState!.validate()) {
      // Recuperar o usuário atualmente autenticado
      User? user = FirebaseAuth.instance.currentUser;
        // Recuperar os valores dos campos dos TextFormFields
        String endereco = _enderecoController.text;
        String numero = _numeroController.text;
        String descricao = _descricaoController.text;
        Future<void> adicionarCampos(String username, String email, String role) async {
          try {
            await FirebaseFirestore.instance.collection('users').add({
              'endereco': endereco,
              'numero': numero,
              'descricao': descricao,
            });
            print('Usuário adicionado com sucesso!');
          } catch (error) {
            print('Erro ao adicionar usuário: $error');
            // Adicione aqui a lógica para lidar com o erro, se necessário
          }
        }
        // Informações adicionadas com sucesso ao Firestore// Faça qualquer outra coisa que você precisa aqui
      } else {
        // Não há usuário atualmente autenticado
        // Possivelmente tratamento de erro aqui
      }
    }
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: Scaffold(
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 20.0,),
              Center(
                child: Container(
                  child: Text('SEJA BEM-VINDO',
                  style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[400]
                   ),
                  ),
                ),
              ),
              SizedBox(height: 20.0,),
              Container(
                child: InkWell(
                  child: Text('Adicione esses Detalhes ao seus Perfil'),
                ),
              ),
              Container(
                child: Text('Preencha com Atenção'),
              ),
              TextFormField(
                controller: _enderecoController,
                decoration: InputDecoration(
                  labelText: 'Endereco',
                  prefixIcon: Icon(Icons.location_city),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _numeroController ,
                decoration: InputDecoration(
                  labelText: 'Contato',
                  prefixIcon: Icon(Icons.numbers),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descricaoController,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  prefixIcon: Icon(Icons.numbers),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um email';
                  }
                  return null;
                },
              ),
          SizedBox(height: 15.0,),
          Container(
            width: 350.0,
            height: 50.0,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child:
              const Text('ENTRAR',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),

            ],
          ),
        ),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }


