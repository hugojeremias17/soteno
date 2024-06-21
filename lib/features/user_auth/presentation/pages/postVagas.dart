import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/comment_button.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/like_button.dart';

class postVagas extends StatefulWidget {
  final String Message;
  final String user;
  final String vagaId;
  final List<String> Likes;
  const postVagas({
      super.key,
      required this.Message,
      required this.user,
      required this.vagaId,
      required this.Likes

  });

  @override
  State<postVagas> createState() => _postVagasState();
}

class _postVagasState extends State<postVagas> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;
  final _commentTextController = TextEditingController();

  @override
  void initState(){
    super.initState();
    isLiked = widget.Likes.contains(currentUser.email!);
  }
  void addComment(String commentText){
    FirebaseFirestore.instance
        .collection("userPosts")
        .doc(widget.vagaId)
        .collection("Comments")
        .add({
            "CommentText": commentText,
            "Commentby": currentUser.email,
            "CommentTime": Timestamp.now()
          });
  }
  void showCommentDialog(){
    String _comentario = _commentTextController.text;
    showDialog(context: context, builder: (context) => AlertDialog(
      title: Text("Adicione um comentário"),
      content: TextField(
        controller: _commentTextController,
        decoration: InputDecoration(
          hintText: "Escreva uma comentário..."
        ),
      ),

      actions: [
        TextButton(
            onPressed: () {
              addComment(_comentario);
              _commentTextController.clear();
            },
            child: Text('comente')
        ),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
              _commentTextController.clear();
            },
            child: Text('cancelar')
        )
      ],
    ));
  }
  void toggleLike(){
    setState(() {
      isLiked = !isLiked;
    });

    DocumentReference vagasRef =
        FirebaseFirestore.instance.collection('userPosts').doc(widget.vagaId) as DocumentReference<Object?>;

      if(isLiked){
        vagasRef.update({
          'Likes': FieldValue.arrayUnion([currentUser.email])
        });
      } else{
        vagasRef.update({
          'Likes': FieldValue.arrayRemove([currentUser.email])
        });
      }
    }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26)
      ),
      margin: EdgeInsets.only(top: 25, left:25, right: 25),
      padding: EdgeInsets.all(25),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle, color: Colors.grey[400],
            ),
            padding: EdgeInsets.all(10),
            child: const Icon(
                Icons.person,
                color: Colors.white,
            ),
          ),
          SizedBox(width: 20,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.user, style: TextStyle(color: Colors.grey[500]),),
              const SizedBox(height: 7,),
              Text(widget.Message),
              SizedBox(height: 7,),
              Row(
                children: [
                  LikeButton(
                      isLiked: isLiked,
                      onTap: toggleLike
                  ),
                  const SizedBox(height: 5,),
                  Text(
                    widget.Likes.length.toString(),
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(width: 5,),
                  CommentButton(onTap: showCommentDialog,),
                  const SizedBox(height: 5,),
                  Text('0', style: const TextStyle(color: Colors.grey),),
                ],
              ),

            ],
          ),

        ],
      ),
    );
  }
}
