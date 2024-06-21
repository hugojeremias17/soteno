import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/empregadorpage.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/empresapage.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/home_page.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/login_page.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/sign_page.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/tecnicopage.dart';
import 'package:sotenooficial/main.dart';
import 'package:sotenooficial/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void main() {
  runApp(contratanteLogin());
}

class contratanteLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: loginContratante(),
        ),
      ),
    );
  }
}

class loginContratante extends StatefulWidget {
  @override
  _loginContratanteState createState() => _loginContratanteState();
}

class _loginContratanteState extends State<loginContratante> {
  bool isSigning = false;
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuthService _auth = FirebaseAuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _roleController = TextEditingController();
  bool _obscureText = true;
  bool _isHidden = true;

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
  Future<void> adicionarUsuarios(
      String email,
      String username,
      String role,
      String password) async {
    try {
      await FirebaseFirestore.instance.collection('users').add({
        'email': email,
        'username': username,
        'role': 'contratante',
        'password': password,
        'uid': FirebaseAuth.instance.currentUser?.uid,

      });
      print('Usuário adicionado com sucesso!');
    } catch (error) {
      print('Erro ao adicionar usuário: $error');
      // Adicione aqui a lógica para lidar com o erro, se necessário
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
    body:Form(
      key: _formKey,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.ideographic,
          children: <Widget>[
            SizedBox(
              height: 100,
            ),
            Container(
              margin: EdgeInsets.only(left: 8),
              child: Image.asset(
                'images/logo1.png',
                height: 90,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 28),
              child: const Column(
                children: [
                  Text(
                    'Seja Bem-vindo,',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Caríssimo/a Contrante',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ),  Center(
                child: Container(
                  child: Column(children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 360,
                      child: TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined,),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.shade200, width: 1.0),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            fillColor: Colors.grey.shade200,
                            filled: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira um email';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      width: 360,
                      child: TextFormField(
                        controller: _usernameController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            labelText: 'Nome de Usuário',
                            prefixIcon: Icon(Icons.person_2_outlined,),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.shade200, width: 1.0),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            fillColor: Colors.grey.shade200,
                            filled: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira um email';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 360,
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: _isHidden,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                            labelText: 'Senha',
                            prefixIcon: Icon(Icons.lock_outlined,),
                            suffixIcon: InkWell(
                              onTap: _togglePasswordView,
                              child: Icon(_isHidden ? Icons.visibility_off : Icons.visibility, color: Colors.black,),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.shade200, width: 1.0),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            fillColor: Colors.grey.shade200,
                            filled: true),

                      ),
                    ),
                    SizedBox(
                      height: 31,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(

                            child: Text('Já tenho um Conta'),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
                            },
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      width: 300,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: _signIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                        ),
                        child:
                        isSigning ? const CircularProgressIndicator(
                          color: Colors.white,) :
                        const Text('E N T R A R',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ]
                  ),
                )
            ),
          ]
      ),
    ),
    );
  }
  void _signIn() async {
    setState(() {
      isSigning = true;
    });
    String email = _emailController.text;
    String password = _passwordController.text;
    String username = _usernameController.text;
    String role = _roleController.text;
    User? user = await _auth.signUpWithEmailAndPassword(
        email,
        password);

    setState(() {
      isSigning = false;
    });
    if (user != null) {
      adicionarUsuarios(
          _emailController.text.trim(),
          _usernameController.text.trim(),
          _roleController.text.trim(),
        _passwordController.text.trim(),

      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EmpregadorPage()),
      );

    } else {
        print(' algum erro');
      }
    }
  }

