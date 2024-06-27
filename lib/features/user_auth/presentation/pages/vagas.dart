import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sotenooficial/features/app/components/text_box.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/SignEmpresa.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/empregadorpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/postVagas.dart';

class vagas extends StatefulWidget {
  const vagas({super.key});

  @override
  State<vagas> createState() => _vagasState();
}

class _vagasState extends State<vagas> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final _textController = TextEditingController();

  void postMessage(){
    if(_textController.text.isNotEmpty){
      FirebaseFirestore.instance.collection("userPosts").add({
        'UserEmail': currentUser?.email!,
        'Message': _textController.text,
        'TimeStamp': Timestamp.now(),
        'Likes' : [],
      });
    }
  setState(() {
    _textController.clear();
  });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        title: Text(
                  " V A G A S",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('userPosts')
                    .orderBy("TimeStamp",
                    descending: false,
                )
                  .snapshots(),
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index){
                        final post = snapshot.data!.docs[index];
                        return postVagas(
                            Message: post['Message'],
                            user: post['UserEmail'],
                            vagaId: post.id,
                            Likes: List<String>.from(post['Likes'] ?? [])
                        );
                      },
                      );
                    }else if(snapshot.hasError){
                      return Center(
                        child: Text('Error:' + snapshot.error.toString()),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
              )
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _textController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: 'Publique uma Vaga',
                        prefixIcon: Icon(
                          Icons.message,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
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
                IconButton(
                    onPressed: postMessage,
                    icon: Icon(Icons.arrow_circle_up_sharp))
              ],
            ),
          ),
          Text("Logado como:${currentUser?.email!}"),
        ],
      ),
    );
  }
}
