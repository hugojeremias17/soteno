
import 'dart:io' as io;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:sotenooficial/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/login_page.dart';
import 'package:sotenooficial/global/common/toast.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/tecnicopage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void main() {
  runApp(SignInPage());
}

class SignInPage extends StatefulWidget {
  _SignInPageState createState() => _SignInPageState();
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


class _SignInPageState extends State<SignInPage> {

  final _formKey = GlobalKey<FormState>();
   bool IsSigningUp = false;
   bool _obscureText = true;
  final FirebaseAuthService _auth = FirebaseAuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _roleController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _idadeController = TextEditingController();
  TextEditingController _enderecoController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();
  bool _isHidden = true;
  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
  final List<String> options = ['Motorista', 'Empregada', 'Canalizador'];
  final List<String> municipios = [
    'Município de Belas',
    'Município de Cacuaco',
    'Município de Cazenga',
    'Município de Ícolo e bengo',
    'Município de Kilamba Kiaxi',
    'Município de Luanda Sul',
    'Município de Talatona',
    'Município de Viana'
  ];
  TextEditingController _funcaoController = TextEditingController();

  Future<void> adicionarCanalizadores(
      String email,
      String role,
      String username,
      String idade,
      String descricao,
      String endereco,
      String funcao,
      String password
      ) async {
      try {
        CollectionReference tecnicosRef = FirebaseFirestore.instance.collection('tecnico');
      Map <String, dynamic> novoUsuario = {
        'email': email,
        'role': 'tecnico',
        'username': username,
        'idade': idade,
        'endereco': endereco,
        'Funcao': funcao,
        'descricao': descricao,
        'password': password,
      };
        await tecnicosRef.add(novoUsuario);
        print('Técnico Adicionado');
      }
      catch (error){
        print('Erro ao adicionar usuario');
      }
  }
  Future<void> adicionarMotoristas(
      String email,
      String role,
      String username,
      String idade,
      String descricao,
      String endereco,
      String funcao,
      String password
      ) async {
    try {
      CollectionReference tecnicosRef = FirebaseFirestore.instance.collection('tecnico');
      Map <String, dynamic> novoUsuario = {
        'email': email,
        'role': 'tecnico',
        'username': username,
        'idade': idade,
        'endereco': endereco,
        'Funcao': funcao,
        'descricao': descricao,
        'password': password,
      };
      await tecnicosRef.add(novoUsuario);
      print('Técnico Adicionado');
    }
    catch (error){
      print('Erro ao adicionar usuario');
    }
  }
  Future<void> adicionarEmpregadas(
      String email,
      String role,
      String username,
      String idade,
      String descricao,
      String endereco,
      String funcao,
      String password
      ) async {
    try {
      CollectionReference tecnicosRef = FirebaseFirestore.instance.collection('tecnico');
      Map <String, dynamic> novoUsuario = {
        'email': email,
        'role': 'tecnico',
        'username': username,
        'idade': idade,
        'descricao': descricao,
        'endereco': endereco,
        'Funcao': funcao,
        'password': password,
      };

      await tecnicosRef.add(novoUsuario);
      print('Usuario Adicionado com sucesso à subcoleção de "tecnico"');
    }
    catch (error){
      print('Erro ao adicionar usuario');
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _roleController.dispose();
    _enderecoController.dispose();
    _descricaoController.dispose();
    _idadeController.dispose();
    _funcaoController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  Column _buildPartOne() {
    String? selectedValue = _funcaoController.text.isNotEmpty ? _funcaoController.text : null;
    String? selecioneValor = _enderecoController.text.isNotEmpty ? _enderecoController.text : null;

    return Column(
      key: ValueKey('part_one'),
      children: [
        Container(
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.ideographic,
            children: [
              SizedBox(
                height: 30,
              ),
              Container(
                margin: EdgeInsets.only(right: 220),
                child: Image.asset(
                  'images/logo1.png',
                  height: 90,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Column(
                  children: [
                    Text('Seja Bem-Vindo!',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    Text('Caríssimo Técnico/a',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Center(
          child: Container(
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 22,),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(left: 20),
                    width: 360,
                    height: 60,
                    child: SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(fontSize: 13),
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
                  ),
                ),
                SizedBox(height: 10,),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(left: 20),
                    width: 360,
                    height: 60,
                    child: SizedBox(
                      width: 360,
                      child: TextFormField(
                        controller: _usernameController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            labelText: 'Nome de Usuário',
                            labelStyle: TextStyle(fontSize: 13),
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
                  ),
                ),
                Container(
                  width: 350,
                  height: 77,
                  child:Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 350,
                      child: DropdownButtonFormField<String>(
                        decoration:  InputDecoration(
                          labelText: 'Funcões',
                          prefixIcon: Icon(Icons.work_outline),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        value: selectedValue,
                        items: options.map((String valor) {
                          return DropdownMenuItem<String>(
                            value: valor,
                            child: Text(valor),
                          );
                        }).toList(),
                        onChanged: (String? novoValor) {
                          setState(() {
                            _enderecoController.text = novoValor ?? '';
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 350,
                  height: 77,
                  child:Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 350,
                      child: DropdownButtonFormField<String>(
                        decoration:  InputDecoration(
                          labelText: 'Município',
                          prefixIcon: Icon(Icons.location_history_outlined),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        value: selecioneValor,
                        items: municipios.map((String valor) {
                          return DropdownMenuItem<String>(
                            value: valor,
                            child: Text(valor),
                          );
                        }).toList(),
                        onChanged: (String? novoValor) {
                          setState(() {
                            _funcaoController.text = novoValor ?? '';
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 360,
                  height: 60,
                  child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 360,
                      child: TextFormField(
                        controller: _idadeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: 'Idade',
                            labelStyle: TextStyle(fontSize: 13),
                            prefixIcon: Icon(Icons.numbers,),
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
                  ),
                ),
                Container(
                  width: 380,
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
                Container(
                  child: Row(
                    children: [
                      SizedBox(width: 10,),
                    ],
                  ),
                ),
              ],
            ) ,
          ),
        ),
      ],
    );
  }

   _buildPartTwo() {
     String? selecioneValor = _enderecoController.text.isNotEmpty ? _enderecoController.text : null;

  }

    @override
    Widget build(BuildContext context) {
      bool isPartOneVisible = true;
      return Scaffold(
        body: Column(
          children: [
            Container(
              child: Form(
                key: _formKey,
                child: Column(

                ),
              ),
            ),
          ],
        ),
      );
    }



  void _signUp() async {

    setState(() {
      IsSigningUp = true;
    });
    String role = _roleController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String Descricao = _descricaoController.text;
    String username = _usernameController.text;
    String idade = _idadeController.text;
    String endereco = _enderecoController.text;
    String funcao = _funcaoController.text;

     User? user = await _auth.signUpWithEmailAndPassword(email, password);
    setState(() {
      IsSigningUp = false;
    });
    if (user != null){
        if(funcao == 'Canalizador') {
          adicionarCanalizadores(
              _emailController.text.trim(),
              _roleController.text.trim(),
              _usernameController.text.trim(),
              _idadeController.text.trim(),
              _descricaoController.text.trim(),
              _enderecoController.text.trim(),
              _funcaoController.text.trim(),
              _passwordController.text.trim(),
          );
          showToast(message: "Técnico Criado com Sucesso");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TecnicoPage()),
          );
        } else if( funcao == 'Empregada') {
          adicionarEmpregadas(
            _emailController.text.trim(),
            _roleController.text.trim(),
            _usernameController.text.trim(),
            _idadeController.text.trim(),
            _descricaoController.text.trim(),
            _enderecoController.text.trim(),
            _funcaoController.text.trim(),
            _passwordController.text.trim(),

          );
          showToast(message: "Técnico Criado com Sucesso");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TecnicoPage()),
          );
        } else if(funcao == 'Motorista' ){
          adicionarMotoristas(
            _emailController.text.trim(),
            _roleController.text.trim(),
            _usernameController.text.trim(),
            _idadeController.text.trim(),
            _descricaoController.text.trim(),
            _enderecoController.text.trim(),
            _funcaoController.text.trim(),
            _passwordController.text.trim(),
          );
          showToast(message: "Técnico Criado com Sucesso");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TecnicoPage()),
          );
        } else{
          print('Função Inválida');
        }

    } else{
      showToast(message: ' algum erro');
    }
  }
}
