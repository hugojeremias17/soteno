import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/login_page.dart';
import 'package:sotenooficial/global/common/toast.dart';
import 'package:sotenooficial/main.dart';



class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title:'SOTENO JOB',
        theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _HomePageScreen(),
    );
  }
}


class _HomePageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget> [
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.home)
          ),
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.notifications)
          ),
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.message)
          ),
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.work)
          ),
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.man)
          ),
        ],
      ),
      body:  Column(
        children: [
          Container(
            child: Text('Seja Bem-Vindo'),
          ),
          Container(
            alignment: Alignment.center,
            width: 180.0,
            height: 60.0,
            child: Center(
              child:ElevatedButton(
                onPressed: () {
                  showToast(message: 'O Usuário saiu da aplicação ');
                  FirebaseAuth.instance.signOut();
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage())
                  );
                },
                child: const Text('Sign Out', style: TextStyle(fontSize: 20.0, color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    /* Container(
            alignment: Alignment.center,
            width: 350.0,
            height: 50.0,
            child: Center(
              child:ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage())
                );
              },
              child: const Text('Sign Out', style: TextStyle(fontSize: 20.0, color: Colors.white),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
               ),
             ),
            ),
          ),*/
  }
}