import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sotenooficial/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuthService _authService = FirebaseAuthService();

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(widget.receiverID, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? currentUser = _authService.currentUser;
    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.receiverEmail),
        ),
        body: Center(child: Text('Erro: Usuário não autenticado.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverEmail),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(currentUser.uid),
          ),
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList(String currentUserID) {
    print('este e o id do usuario corrente $currentUserID');
    return StreamBuilder<QuerySnapshot>(
      stream: _chatService.getMessages(widget.receiverID, currentUserID ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print('Snapshot has error: ${snapshot.error}');
          return const Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(color: Colors.blue);
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text("Nenhuma mensagem encontrada.");
        }
        return ListView(
          children: snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    final User? currentUser = _authService.currentUser;
    bool isCurrentUser = data['senderID'] == currentUser?.uid;

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          color: isCurrentUser ? Colors.blue[200] : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          data['message'],
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: "Escreva uma Mensagem",
              ),
            ),
          ),
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(Icons.arrow_circle_up_sharp),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
