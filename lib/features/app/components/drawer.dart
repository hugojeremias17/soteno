import 'package:flutter/material.dart';
import 'package:sotenooficial/features/app/components/minhalistaTituto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/perfilpageEmpregador.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/tecnicopage.dart';
class MyDrawer extends StatelessWidget {
  final void Function()? onProfileTap;
  final void Function()? onSignOut;
  const MyDrawer({
    super.key,
    required this.onProfileTap,
    required this.onSignOut});
  @override
  Widget build(BuildContext context) {
    return  Drawer(
      backgroundColor: Colors.blueGrey,
      child: Column(
        children: [
          const DrawerHeader(
            child: Icon(
              Icons.person_2_outlined,
              color: Colors.white,
              size: 62,
            ),
          ),
          SizedBox(height: 10.0,),
          minhaLista(
            icon: Icons.home,
            text: 'H O M E',
              iconColor: Colors.white,
            onTap: () => Navigator.pop(context)
            ),
          SizedBox(height: 10.0,),
          minhaLista(
              icon: Icons.person,
              text: 'P E R F I L',
              iconColor: Colors.white,
              onTap: onProfileTap
          ),
          SizedBox(height: 10.0,),
          minhaLista(
              icon: Icons.work,
              text: 'V A G A S',
              iconColor: Colors.white,
              onTap: () {}
          ),
          SizedBox(height: 350.0,),
          minhaLista(
              icon: Icons.logout,
              text: 'S A I R',
              iconColor: Colors.red,
              onTap: onSignOut
          ),
        ],
      ),
    );
  }
}
