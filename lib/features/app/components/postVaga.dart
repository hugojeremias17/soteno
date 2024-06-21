import 'package:flutter/material.dart';
class postVagas extends StatelessWidget {
  final String message;
  final String userEmail;
  const postVagas({super.key,
    required this.message,
    required this.userEmail,

  });
  
 
    factory postVagas.fromJson(Map<String, dynamic> json) {
      return postVagas(
        message: json['message'] as String ?? '',
        userEmail: json['UserEmail'] as String ?? '',
      );
   
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

