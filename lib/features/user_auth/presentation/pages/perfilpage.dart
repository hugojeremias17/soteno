import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:sotenooficial/features/app/components/text_box.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class perfilPage extends StatefulWidget {
  const perfilPage({super.key});

  @override
  State<perfilPage> createState() => _perfilPageState();
}

class _perfilPageState extends State<perfilPage> {

   String tProfile = "Profile";
   FirebaseAuth _auth = FirebaseAuth.instance;
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection("users");
  FirebaseFirestore _firestore = FirebaseFirestore.instance;


   @override
   void initState() {
     super.initState();
   }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(LineAwesomeIcons.angle_left),),
            title:  Text('Perfil'),
            actions: [
              IconButton(onPressed: () {},
                  icon: const Icon(LineAwesomeIcons.moon),),
            ],
        ),
        body: SingleChildScrollView(
          child: Container(

          ),
        ),
      );
    }
  }


