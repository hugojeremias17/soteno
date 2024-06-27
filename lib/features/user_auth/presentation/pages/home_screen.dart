import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/empregadorpage.dart';
import 'chat_provider.dart';
import 'search_screen.dart';
import '../widget/chat_tile.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  User? loggedInUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        loggedInUser = user;
      });
    }
  }

  Future<Map<String, dynamic>> _fetchChatData(String chatId) async {
    try {
      final chatDoc = await FirebaseFirestore.instance.collection('chats').doc(chatId).get();
      final chatData = chatDoc.data();
      if (chatData == null) throw Exception("Chat data is null for chatId: $chatId");

      final users = chatData['users'] as List<dynamic>;
      final receiverId = users.firstWhere((uid) => uid != loggedInUser!.uid, orElse: () => null);

      if (receiverId == null) throw Exception("Receiver ID is null for chatId: $chatId");

      final userQuery = await FirebaseFirestore.instance.collection('users').where('uid', isEqualTo: receiverId).get();
      if (userQuery.docs.isEmpty) throw Exception("User data is null for receiverId: $receiverId");

      final userData = userQuery.docs.first.data();

      return {
        'chatId': chatId,
        'lastMessage': chatData['lastMessage'] ?? '',
        'timestamp': chatData['timestamp']?.toDate() ?? DateTime.now(),
        'userData': userData,
      };
    } catch (e) {
      print("Error fetching chat data for chatId $chatId: $e");
      return {
        'chatId': chatId,
        'lastMessage': '',
        'timestamp': DateTime.now(),
        'userData': {'username': 'Unknown', 'funcao': 'Unknown', 'idade': 'Unknown'},
      };
    }
  }



  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Conversas"),
        actions: [
          IconButton(
            onPressed: () {
              _auth.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Empregador()),
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: loggedInUser == null
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: chatProvider.getChats(loggedInUser!.uid),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final chatDocs = snapshot.data!.docs;
                if (chatDocs.isEmpty) {
                  return Center(child: Text("No chats available"));
                }

                return FutureBuilder<List<Map<String, dynamic>>>(
                  future: Future.wait(chatDocs.map((chatDoc) => _fetchChatData(chatDoc.id))),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final chatDataList = snapshot.data!.where((chatData) => chatData.isNotEmpty).toList();
                    if (chatDataList.isEmpty) {
                      return Center(child: Text("No valid chat data"));
                    }

                    return ListView.builder(
                      itemCount: chatDataList.length,
                      itemBuilder: (context, index) {
                        final chatData = chatDataList[index];
                        return ChatTile(
                          chatId: chatData['chatId'],
                          lastMessage: chatData['lastMessage'],
                          timestamp: chatData['timestamp'],
                          receiverData: chatData['userData'],
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orangeAccent,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SearchScreen()),
          );
        },
        child: Icon(Icons.search),
      ),
    );
  }
}
