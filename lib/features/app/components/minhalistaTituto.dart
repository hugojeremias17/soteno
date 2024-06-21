import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class minhaLista extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;
  void Function()? onTap;

   minhaLista({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
     required this.iconColor
  });

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding:  EdgeInsets.only(left: 10.0),
      child: ListTile(
        leading: Icon(
          icon,
          color: iconColor,
        ),
        onTap:onTap,
        title: Text(text,
        style: const TextStyle(color: Colors.white),),
      ),
    );
  }

}
