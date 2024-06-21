
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:sotenooficial/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/canalizador.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/chat_home.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/home_screen.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/perfilpage.dart';
import 'package:sotenooficial/main.dart';
import 'package:sotenooficial/global/common/toast.dart';
import 'package:sotenooficial/features/app/components/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(TecnicoPage());
}

class TecnicoPage extends StatelessWidget {
  void VaiproPerfil(BuildContext context) {
    Navigator.pop(context,
        MaterialPageRoute(builder: (context) => perfilPage()));
  }
  const TecnicoPage({super.key});


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Tecnico',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Tecnico(),
    );
  }
}

class Tecnico extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
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
                                  MaterialPageRoute(builder: (context) => TecnicoPage())
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
                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                            },
                            icon: Icon(Icons.message_outlined)
                        ),
                        Text('C H A T', style: TextStyle(
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
                            onPressed: () {
                              FirebaseAuth.instance.signOut();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => MyHomePage())
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
        drawer:  MyDrawer(
          onProfileTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => perfilPage())
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
              child: Text('Página dos Técnicos'),
            ),
            Container(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CanalizadoresPage()));
                },
                child: Text('Veja os Canalizadores agora '),
              ),
            )
          ],
        ),
     ),
      );
  }
  }

