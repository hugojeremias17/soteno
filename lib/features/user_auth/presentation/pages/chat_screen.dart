import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'chat_provider.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final String? chatId;
  final String receiverId;


  const ChatScreen({super.key, required this.chatId, required this.receiverId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  User? loggedInUser;
  String? chatId;

  @override
  void initState() {
    super.initState();
    chatId = widget.chatId;
    getCurrentUser();
    print(widget.receiverId);
  }

  void getCurrentUser() {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        loggedInUser = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final TextEditingController _textController = TextEditingController();

    return FutureBuilder(
      future: _firestore.collection('users').where('uid', isEqualTo: widget.receiverId).get(),

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && snapshot.data != null) {
            final recevierData = snapshot.data!.docs[0].data() as Map<String, dynamic>?;
            print('abaixo tem o id do recebedor');
            print( widget.receiverId);
            print('acima temos o id do recebedor');
            if (recevierData != null) {
              return Scaffold(
                backgroundColor: Color(0xFFEEEEEE),
                appBar: AppBar(
                  title: Row(
                    children: [
                      CircleAvatar(
                        child: Icon(Icons.person, size: 20,),
                      ),
                      SizedBox(width: 6),
                      Text(recevierData['email']),
                    ],
                  ),
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: chatId != null && chatId!.isNotEmpty
                          ? MessagesStream(chatId: chatId!)
                          : Center(
                        child: Text("Nenhuma mensagem ainda"),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _textController,
                              decoration: InputDecoration(
                                hintText: "Digite a sua mensagem...",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              if (_textController.text.isNotEmpty) {
                                if (chatId == null || chatId!.isEmpty) {
                                  chatId = await chatProvider.createChatRoom(widget.receiverId);
                                }
                                if (chatId != null) {
                                  chatProvider.sendMessage(chatId!, _textController.text, widget.receiverId);
                                  _textController.clear();
                                }
                              }
                            },
                            icon: Icon(
                              Icons.send,
                              color: Color(0xFF3876FD),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Scaffold(
                appBar: AppBar(),
                body: Center(
                  child: Text("Erro: Usuário não encontrado."),
                ),
              );
            }
          } else {
            return Scaffold(
              appBar: AppBar(),
              body: Center(
                child: Text("Erro: Falha ao carregar dados do usuário."),
              ),
            );
          }
        }
        return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

class MessagesStream extends StatelessWidget {
  final String chatId;

  const MessagesStream({super.key, required this.chatId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final messages = snapshot.data!.docs;
        List<MessageBubble> messageWidgets = [];
        for (var message in messages) {
          final messageData = message.data() as Map<String, dynamic>?;
          if (messageData != null) {
            final messageText = messageData['messageBody'];
            final messageSender = messageData['senderId'];
            final timestamp =
                messageData['timestamp'] ?? FieldValue.serverTimestamp();

            final currentUser = FirebaseAuth.instance.currentUser!.uid;

            final messageWidget = MessageBubble(
              sender: messageSender,
              text: messageText,
              isMe: currentUser == messageSender,
              timestamp: timestamp,
            );
            messageWidgets.add(messageWidget);
          }
        }
        return ListView(
          reverse: true,
          children: messageWidgets,
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;
  final bool isMe;
  final dynamic timestamp;

  const MessageBubble(
      {super.key,
        required this.sender,
        required this.text,
        required this.isMe,
        this.timestamp});

  @override
  Widget build(BuildContext context) {
    final DateTime messageTime =
    (timestamp is Timestamp) ? timestamp.toDate() : DateTime.now();

    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment:
        isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isMe ? Colors.blueAccent : Colors.grey,
              borderRadius: isMe
                  ? BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              )
                  : BorderRadius.only(
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(height: 5),
          Text(
            messageTime.toLocal().toString(),
            style: TextStyle(fontSize: 10, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
