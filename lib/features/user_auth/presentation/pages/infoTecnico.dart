import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sotenooficial/features/app/splash_screen/splash_screen.dart';
import 'package:sotenooficial/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/home_page.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/login_page.dart';
import 'package:sotenooficial/global/common/toast.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/tecnicopage.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/empresapage.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/empregadorpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/criarperfilTecnico.dart';
import 'sign_page.dart';



void main() {
  runApp(infoTecnico());
}

class UserData {
  final String password;
  final String username;
  final String email;
  final String role;
  final String endereco;
  final String idade;
  final String descricao;

  UserData({
    required this.password,
    required this.username,
    required this.email,
    required this.role,
    required this.endereco,
    required this.idade,
    required this.descricao,
  });

  Map<String, dynamic> toMap() {
    return {
      'passoword': password,
      'username': username,
      'email': email,
      'role': role,
      'endereco': endereco,
      'idade': idade,
      'descricao': descricao,
    };
  }
}


class infoTecnico extends StatefulWidget {
  _infoTecnicoState createState() => _infoTecnicoState();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center( child: Text('CADASTRAR'),),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: MyForm(),
        ),
      ),
    );
  }
}


class _infoTecnicoState extends State<infoTecnico> {

  final _formKey = GlobalKey<FormState>();
  bool IsSigningUp = false;
  final FirebaseAuthService _auth = FirebaseAuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _idadeController = TextEditingController();
  TextEditingController _enderecoController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();

  /*void adicionarDados(UserData userData) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;
        await FirebaseFirestore.instance.collection('users').doc(userId).set(
          userData.toMap(),
          SetOptions(merge: true), // Use merge: true para adicionar campos sem substituir o documento inteiro
        );
        print('Dados adicionados com sucesso!');
      } else {
        print('Usuário não autenticado');
      }
    } catch (error) {
      print('Erro ao adicionar dados: $error');
      // Lidar com erros, se necessário
    }
  }*/
  /*Future<void> adicionarUsuarios(String username, String email, String role) async {
    try {
      await FirebaseFirestore.instance.collection('users').add({
        'username': username,
        'email': email,
        'role': role,
      });
      print('Usuário adicionado com sucesso!');
    } catch (error) {
      print('Erro ao adicionar usuário: $error');
      // Adicione aqui a lógica para lidar com o erro, se necessário
    }
  }*/

  Future<String?> encontrarIdDoUsuarioAtual() async {
    try {
      // Obtendo o usuário atualmente autenticado
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Obtendo uma referência ao documento do usuário na coleção "users" usando o ID do usuário autenticado
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        if (documentSnapshot.exists) {
          // Retornando o ID do documento do usuário
          return documentSnapshot.id;
        } else {
          print('Documento do usuário não encontrado');
          return null;
        }
      } else {
        print('Usuário não autenticado');
        return null;
      }
    } catch (error) {
      print('Erro ao encontrar ID do usuário atual: $error');
      return null;
    }
  }

// Função para adicionar informações adicionais ao usuário
  Future<void> adicionarInformacoesAdicionaisAoUsuario(String userId, String novaInformacao) async {
    try {
      // Referência ao documento do usuário na coleção "users"
      DocumentReference usuarioRef = FirebaseFirestore.instance.collection('users').doc(userId);
      print(userId);

      // Atualizar o documento existente na coleção "users" com as novas informações
      await usuarioRef.update({
        'user': userId,
        'descricao': _descricaoController,
        // Adicione outros campos ou atualizações conforme necessário
      });

      print('Informações adicionais adicionadas com sucesso ao usuário com ID: $userId');
    } catch (error) {
      print('Erro ao adicionar informações adicionais ao usuário: $error');
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _idadeController.dispose();
    _descricaoController.dispose();
    _enderecoController;
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:  Container(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                height: 300.0,
                child: const CircleAvatar(
                  radius: 90.0,
                  backgroundColor: Colors.red,
                  backgroundImage: AssetImage('images/domestica.jpg'),
                ),
              ),
              Container(
                child: const Column(
                  children: [
                    Text('Preencha os Campos',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),),
                    Text('adicione cada detalhe',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),)
                  ],
                ),
              ),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Nome de Usuário',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um nome de Usuario';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _idadeController,
                decoration: const InputDecoration(
                  labelText: 'Idade',
                  prefixIcon: Icon(Icons.numbers_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira sua idade';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: TextFormField(
                  controller: _enderecoController,
                  decoration: InputDecoration(
                    labelText: 'Endereço',
                    prefixIcon: Icon(Icons.location_history_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira uma senha';
                    }
                    return null;
                  },
                ),
              ),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  prefixIcon: Icon(Icons.text_fields_rounded),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira sua idade';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0,),
              Container(
                width: 350.0,
                height: 50.0,
                child: ElevatedButton(
                  onPressed: () async {
                    // Obter o ID do usuário atual
                    String? userId = await encontrarIdDoUsuarioAtual();
                    if (userId != null) {
                      // Adicionar informações adicionais ao usuário
                      await adicionarInformacoesAdicionaisAoUsuario(userId, 'Nova informação');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child:  const Text('CADASTRAR',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0,),
              Container(
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Já tem uma conta?',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,),
                    ),
                    InkWell(
                      child:
                      Text('Entre'),

                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage())
                        );
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  /*void _signUp() async {

    setState(() {
      IsSigningUp = true;
    });
    String role = _roleController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signUpWithEmailAndPassword(email, password);
    setState(() {
      IsSigningUp = false;
    });
    if (user != null){
      if (_roleController.text == 'tecnico') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TecnicoPage()),
        );
        showToast(message: "Técnico foi criado com sucesso");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TecnicoPage()),
        );

      } else if (_roleController.text == 'empresa') {
        adicionarUsuarios(
            _usernameController.text.trim(),
            _emailController.text.trim(),
            _roleController.text.trim()
        );
        showToast(message: "Empresa foi criada com sucesso");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Empresa()),
        );
      } else if (_roleController.text == 'contratante') {
        adicionarUsuarios(
            _usernameController.text.trim(),
            _emailController.text.trim(),
            _roleController.text.trim()
        );
        showToast(message: "Contratante foi criado com sucesso");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Empregador()),
        );
      } else {
        showToast(message: "Usuário foi criado com sucesso");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    } else{
      showToast(message: ' algum erro');
    }
  }*/
 /* void _adicionarInfo() async {
    if (_formKey.currentState!.validate()) {
      User? user = FirebaseAuth.instance.currentUser;

      //verificar se o usuario está atenticado
      if (user != null){
        String userId = user.uid;
        // Recuperar os valores dos campos dos TextFormFields
        String username = _usernameController.text;
        String endereco = _enderecoController.text;
        String idade = _idadeController.text;
        String descricao = _descricaoController.text;
        // Chamar o método para adicionar os campos no Firestore
        await adicionarCampos(username, endereco, idade, descricao);
      }

    } else {
      // Possivelmente tratamento de erro aqui
    }
  }

  Future<void> adicionarCampos(String username, String endereco, String idade, String descricao) async {
    try {
      await FirebaseFirestore.instance.collection('users').add({
        'endereco': endereco,
        'idade': idade,
        'descricao': descricao,
        'username': username,
      });
      print('Usuário adicionado com sucesso!');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TecnicoPage()),
      );
    } catch (error) {
      print('Erro ao adicionar usuário: $error');
      // Adicione aqui a lógica para lidar com o erro, se necessário
    }

  }*/






}
