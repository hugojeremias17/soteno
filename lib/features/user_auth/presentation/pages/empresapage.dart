import 'package:flutter/material.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/canalizador.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/empregadas.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/empregadorpage.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/home_page.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/login_page.dart';
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
        appBar: AppBar(
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Empresa(),
        ),
      ),
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
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.orange,
          actions: [
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EmpresaPage())
                            );
                          },
                          icon: Icon(Icons.home_outlined),
                        ),
                        Text('H O M E', style: TextStyle(
                            fontSize: 8.0,
                            color: Colors.white
                        ),)
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => vagas()),
                              );
                            },
                            icon: Icon(Icons.work_outline)
                        ),
                        Text('V A G A S', style: TextStyle(
                            fontSize: 8.0,
                            color: Colors.white
                        ),)
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.person_2_outlined)
                        ),
                        Text('T E C N I C O', style: TextStyle(
                            fontSize: 8.0,
                            color: Colors.white
                        ),)
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      children: [
                        IconButton(
                            onPressed: () {
                              FirebaseAuth.instance.signOut();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyHomePage())
                              );
                            },
                            icon: Icon(Icons.notifications_outlined)
                        ),
                        Text(' N O T I F ', style: TextStyle(
                            fontSize: 8.0,
                            color: Colors.white
                        ),)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        drawer: MyDrawer(
          onProfileTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Empresa())
            );
          },
          onSignOut: () {
            FirebaseAuth.instance.signOut();
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage())
            );
          },
        ),
        body: Column(
          children: [
            Container(
              child: Text('Página das Empresas'),
            ),
            Container(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CanalizadoresPage() ));
                },
                child: Text('Veja os Canalizadores '),
              ),
            ),
            Container(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EmpregadasPage() ));
                },
                child: Text('Veja as Empregadas'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
