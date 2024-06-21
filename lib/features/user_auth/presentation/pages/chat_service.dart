import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/models/message.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Método para gerar o chatRoomID consistentemente
  String _generateChatRoomID(String userID1, String userID2) {
    List<String> ids = [userID1, userID2];
    ids.sort(); // Garantir ordem consistente
    return ids.join('_');
  }

  Future<void> sendMessage(String receiverID, String message) async {
    final User? currentUser = _auth.currentUser;

    if (currentUser == null) {
      print('User not authenticated.');
      return;
    }

    final String currentUserID = currentUser.uid;
    final String currentUserEmail = currentUser.email!;
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderEmail: currentUserEmail,
      senderID: currentUserID,
      receiverID: receiverID,
      message: message,
      timestamp: timestamp,
    );

    String chatRoomID = _generateChatRoomID(currentUserID, receiverID);

    print('Sending message to chatRoomID: $chatRoomID'); // Log

    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessages(String currentUserID, String receiverID) {
    String chatRoomID = _generateChatRoomID(currentUserID, receiverID);

    print('Getting messages from chatRoomID: $chatRoomID'); // Log

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore.collection("users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return doc.data();
      }).toList();
    });
  }
}
