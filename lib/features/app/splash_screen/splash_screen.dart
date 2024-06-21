import 'package:flutter/material.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/login_page.dart';

class splash_scren extends StatefulWidget {
  const splash_scren({super.key});

  @override
  State<splash_scren> createState() => _splash_screnState();
}

class _splash_screnState extends State<splash_scren> {

  @override
  void initState() {
    Future.delayed(
      Duration(
          seconds: 3), (){
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(
                builder: (context) =>
                    LoginPage()), (route) => false);
    }
    );
    // TODO: implement initState

  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Seja Bem Vindo à SOTENO',
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),),
      ),
    );
  }
}
