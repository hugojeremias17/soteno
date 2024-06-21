import 'package:flutter/material.dart';
import 'package:sotenooficial/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/chat_service.dart';
import 'user_title.dart';
import 'chat_page.dart';

class ChatHome extends StatelessWidget {
  ChatHome({super.key});
  final ChatService _chatService = ChatService();
  final FirebaseAuthService _auth = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
      ),
      body: _buildUserList(context),
    );
  }

  Widget _buildUserList(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _chatService.getUserStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(color: Colors.grey);
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text("No users available");
        }
        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
    final email = userData['email'] ?? 'No email';
    final uid = userData['uid'] ?? 'uid';
    if (email != _auth.currentUser?.email) {
      // Verifique outros campos necessários da mesma maneira, se necessário
      return UserTile(
        text: email,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverEmail: email,
                receiverID: uid,
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}

