import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  Stream<List<String>> getFavoritesStream() {
    final userId = currentUserId;
    if (userId == null) {
      // Return empty stream if no user is logged in
      return Stream.value([]);
    }
    
    return _firestore.collection('users').doc(userId).snapshots().map((doc) {
      if (doc.exists && doc.data() != null) {
        final List<dynamic>? favs = doc.data()!['favorites'];
        if (favs != null) {
          return favs.cast<String>();
        }
      }
      return <String>[];
    });
  }

  Future<void> toggleFavorite(String centerId, bool isCurrentlyFavorite) async {
    final userId = currentUserId;
    if (userId == null) {
      // User must be logged in to save favorites.
      throw Exception('User not logged in');
    }

    final userRef = _firestore.collection('users').doc(userId);
    
    if (isCurrentlyFavorite) {
      // Remove from favorites
      await userRef.set({
        'favorites': FieldValue.arrayRemove([centerId])
      }, SetOptions(merge: true));
    } else {
      // Add to favorites
      await userRef.set({
        'favorites': FieldValue.arrayUnion([centerId])
      }, SetOptions(merge: true));
    }
  }
}
