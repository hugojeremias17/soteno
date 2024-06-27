import 'package:flutter/material.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/canalizador.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/empregadas.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/empregadorpage.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/home_page.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/home_screen.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/login_page.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/perfilEmpresa.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/sign_page.dart';
import 'package:sotenooficial/features/app/components/drawer.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/vagas.dart';
import 'package:sotenooficial/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sotenooficial/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
void main() {
  runApp(EmpresaPage());
}

class EmpresaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body:  Empresa(),
        )
    );
  }
}

class Empresa extends StatefulWidget {
  @override
  _EmpresaPageState createState() => _EmpresaPageState();
}

class _EmpresaPageState extends State<Empresa> {
  bool isSigning = false;
  final FirebaseAuthService _auth = FirebaseAuthService();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(30))),
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 100,
                      child: Image.asset('images/logo1.png'),
                    ),
                    Container(
                      child: CircleAvatar(
                        backgroundColor: Colors.orangeAccent,
                        child: Icon(Icons.person, color: Colors.white,),

                      ),
                    ),
                    Text(
                      'Encontre o Seu',
                      style: TextStyle(color: Colors.black87, fontSize: 27),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      'Funcionário',
                      style: TextStyle(color: Colors.black87, fontSize: 40),
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(244, 243, 243, 1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Promo Today',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    promoCard('images/Baba.jpg'),
                    promoCard('images/cozinheiro.jpg'),
                    promoCard('images/mecanico.jpg'),
                    promoCard('images/Baba.jpg'),
                  ],
                ),
              ),
              SizedBox(height: 25,),
              Center(
                child: Container(
                  width: 263,
                  height: 54,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.orangeAccent,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5), // Cor da sombra
                          spreadRadius: 3, // Espalhamento da sombra
                          blurRadius: 7, // Desfoque da sombra
                          offset: Offset(0, 3), // Deslocamento da sombra (horizontal, vertical)
                        ),
                      ]
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.home_outlined,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                        SizedBox(width: 3,),
                        IconButton(
                          icon: Icon(
                            Icons.person_2_outlined,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => perfilEmpresa()));
                          },
                        ),
                        SizedBox(width: 5,),
                        IconButton(
                          icon: Icon(
                            Icons.work_outline,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => vagas()));
                          },
                        ),
                        SizedBox(width: 5,),
                        IconButton(
                          icon: Icon(
                            Icons.message_outlined,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
                          },
                        ),
                        SizedBox(width: 5,),
                        IconButton(
                          icon: Icon(
                            Icons.logout_outlined,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyHomePage())
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget promoCard(image) {
    return AspectRatio(
      aspectRatio: 2 / 3,
      child: Container(
        margin: EdgeInsets.only(left: 12),
        decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(image),
            )),
      ),
    );
  }
}
