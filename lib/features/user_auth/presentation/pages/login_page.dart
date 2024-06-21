import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

import '../../../../global/common/toast.dart';

void main() {
  runApp(LoginPage());
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: MyForm(),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  bool isSigning = false;
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuthService _auth = FirebaseAuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isHidden = true;

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  Future<void> signInAndVerify(String email, String password) async {
    setState(() {
      isSigning = true;
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        CollectionReference users = FirebaseFirestore.instance.collection('users');

        QuerySnapshot querySnapshot = await users.where('email', isEqualTo: email).get();

        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot doc = querySnapshot.docs.first;
          String role = doc['role'];
          if (role == 'tecnico') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => TecnicoPage()),
            );
          } else if (role == 'contratante') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => EmpregadorPage()),
            );
          } else if (role == 'empresa') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => EmpresaPage()),
            );
          } else {
            print('Papel de usuário desconhecido');
          }
        } else {
          print('Email não encontrado');
        }
      } else {
        print('Usuário não encontrado');
      }
    } catch (e) {
      print('Erro ao fazer login: $e');
      showToast(message: 'Email ou Senha Inválido');
    }

    setState(() {
      isSigning = false;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 150),
            Container(
              margin: EdgeInsets.only(right: 43),
              child: Image.asset(
                'images/logo1.png',
                height: 90,
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 38),
              child: const Column(
                children: [
                  Text(
                    'Seja Bem-vindo',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Inicie a sua Sessão',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Container(
                    width: 410,
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade200, width: 1.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira um email';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 410,
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: _isHidden,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        prefixIcon: Icon(Icons.lock_outlined),
                        suffixIcon: InkWell(
                          onTap: _togglePasswordView,
                          child: Icon(
                            _isHidden ? Icons.visibility_off : Icons.visibility,
                            color: Colors.black,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade200, width: 1.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                      ),
                    ),
                  ),
                  SizedBox(height: 22),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          child: Text('CADASTRE-SE'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyHomePage()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 300,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          signInAndVerify(_emailController.text, _passwordController.text);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                      ),
                      child: isSigning
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                        'E N T R A R',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

