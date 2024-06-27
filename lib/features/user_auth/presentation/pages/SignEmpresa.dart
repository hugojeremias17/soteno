import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/empresapage.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/sign_page.dart';
import 'package:sotenooficial/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(EmpresaSign());
}

class EmpresaSign extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('LOGIN')),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: SignEmpresa(),
        ),
      ),
    );
  }
}

class SignEmpresa extends StatefulWidget {
  @override
  _SignEmpresaState createState() => _SignEmpresaState();
}

class _SignEmpresaState extends State<SignEmpresa> {
  bool isSigning = false;
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuthService _auth = FirebaseAuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nifController = TextEditingController();
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _roleController = TextEditingController();
  User? get currentUser => _auth.currentUser;
  bool _isHidden = true;

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  Future<void> adicionarUsuarios(String nome, String email, String nif, String password, String role) async {
    try {
      await FirebaseFirestore.instance.collection('users').add({
        'username': nome,
        'email': email,
        'nif': nif,
        'password': password,
        'role': 'empresa',
        'uid': FirebaseAuth.instance.currentUser?.uid,
      });
      print('Usuário adicionado com sucesso!');
    } catch (error) {
      print('Erro ao adicionar usuário: $error');
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _nifController.dispose();
    _passwordController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 70),
              Container(
                margin: EdgeInsets.only(left: 8),
                child: Image.asset(
                  'images/logo1.png',
                  height: 90,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 28),
                child: Column(
                  children: [
                    Text(
                      'Seja Bem-vindo,',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Cara Empresa',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        child: TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.shade200, width: 1.0),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            fillColor: Colors.grey.shade200,
                            filled: true,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira um email';
                            } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                              return 'Por favor, insira um email válido';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        child: TextFormField(
                          controller: _nomeController,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            labelText: 'Nome da Empresa',
                            prefixIcon: Icon(Icons.person_2_outlined),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.shade200, width: 1.0),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            fillColor: Colors.grey.shade200,
                            filled: true,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira o nome da empresa';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        child: TextFormField(
                          controller: _nifController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'NIF',
                            prefixIcon: Icon(Icons.numbers),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.shade200, width: 1.0),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            fillColor: Colors.grey.shade200,
                            filled: true,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira o NIF';
                            } else if (value.length != 9) {
                              return 'O NIF deve ter exatamente 9 caracteres';
                            } else if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
                              return 'O NIF deve conter apenas letras e números';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: double.infinity,
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
                              borderSide: BorderSide(
                                  color: Colors.grey.shade200, width: 1.0),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            fillColor: Colors.grey.shade200,
                            filled: true,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira uma senha';
                            } else if (value.length < 6) {
                              return 'A senha deve ter pelo menos 6 caracteres';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 13),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              child: Text('CADASTRE-SE'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => SignInPage()),
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
                          onPressed: _signIn,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent,
                          ),
                          child: isSigning
                              ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                              : Text(
                            'E N T R A R',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signIn() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }
    setState(() {
      isSigning = true;
    });
    String nome = _nomeController.text;
    String email = _emailController.text;
    String nif = _nifController.text;
    String password = _passwordController.text;

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    setState(() {
      isSigning = false;
    });
    if (user != null) {
      adicionarUsuarios(
        nome.trim(),
        email.trim(),
        nif.trim(),
        password.trim(),
        'empresa',
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EmpresaPage()),
      );
    } else {
      print(' algum erro');
    }
  }
}
