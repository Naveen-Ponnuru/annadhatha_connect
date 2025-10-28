import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Generic document operations
  Future<DocumentSnapshot?> getDocument(String collection, String docId) async {
    try {
      return await _firestore.collection(collection).doc(docId).get();
    } catch (e) {
      throw Exception('Failed to get document: $e');
    }
  }

  Future<void> setDocument(String collection, String docId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).doc(docId).set(data);
    } catch (e) {
      throw Exception('Failed to set document: $e');
    }
  }

  Future<void> updateDocument(String collection, String docId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).doc(docId).update(data);
    } catch (e) {
      throw Exception('Failed to update document: $e');
    }
  }

  Future<void> deleteDocument(String collection, String docId) async {
    try {
      await _firestore.collection(collection).doc(docId).delete();
    } catch (e) {
      throw Exception('Failed to delete document: $e');
    }
  }

  // Collection queries
  Future<QuerySnapshot> getCollection(String collection, {
    Query<Map<String, dynamic>>? query,
    int? limit,
  }) async {
    try {
      Query<Map<String, dynamic>> baseQuery = _firestore.collection(collection);
      
      if (query != null) {
        baseQuery = query;
      }
      
      if (limit != null) {
        baseQuery = baseQuery.limit(limit);
      }
      
      return await baseQuery.get();
    } catch (e) {
      throw Exception('Failed to get collection: $e');
    }
  }

  // Stream operations
  Stream<QuerySnapshot> streamCollection(String collection, {
    Query<Map<String, dynamic>>? query,
    int? limit,
  }) {
    try {
      Query<Map<String, dynamic>> baseQuery = _firestore.collection(collection);
      
      if (query != null) {
        baseQuery = query;
      }
      
      if (limit != null) {
        baseQuery = baseQuery.limit(limit);
      }
      
      return baseQuery.snapshots();
    } catch (e) {
      throw Exception('Failed to stream collection: $e');
    }
  }

  Stream<DocumentSnapshot> streamDocument(String collection, String docId) {
    try {
      return _firestore.collection(collection).doc(docId).snapshots();
    } catch (e) {
      throw Exception('Failed to stream document: $e');
    }
  }

  // Batch operations
  Future<void> batchWrite(List<BatchOperation> operations) async {
    try {
      final batch = _firestore.batch();
      
      for (final operation in operations) {
        switch (operation.type) {
          case BatchOperationType.set:
            batch.set(
              _firestore.collection(operation.collection).doc(operation.docId),
              operation.data!,
            );
            break;
          case BatchOperationType.update:
            batch.update(
              _firestore.collection(operation.collection).doc(operation.docId),
              operation.data!,
            );
            break;
          case BatchOperationType.delete:
            batch.delete(
              _firestore.collection(operation.collection).doc(operation.docId),
            );
            break;
        }
      }
      
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to batch write: $e');
    }
  }

  // Transaction operations
  Future<T> runTransaction<T>(Future<T> Function(Transaction transaction) transactionFunction) async {
    try {
      return await _firestore.runTransaction(transactionFunction);
    } catch (e) {
      throw Exception('Failed to run transaction: $e');
    }
  }

  // Pagination
  Future<QuerySnapshot> getPaginatedCollection(
    String collection, {
    DocumentSnapshot? startAfter,
    int limit = 20,
    Query<Map<String, dynamic>>? query,
  }) async {
    try {
      Query<Map<String, dynamic>> baseQuery = _firestore.collection(collection);
      
      if (query != null) {
        baseQuery = query;
      }
      
      if (startAfter != null) {
        baseQuery = baseQuery.startAfterDocument(startAfter);
      }
      
      return await baseQuery.limit(limit).get();
    } catch (e) {
      throw Exception('Failed to get paginated collection: $e');
    }
  }

  // Search operations
  Future<QuerySnapshot> searchCollection(
    String collection,
    String field,
    String searchTerm, {
    int limit = 20,
  }) async {
    try {
      return await _firestore
          .collection(collection)
          .where(field, isGreaterThanOrEqualTo: searchTerm)
          .where(field, isLessThan: searchTerm + '\uf8ff')
          .limit(limit)
          .get();
    } catch (e) {
      throw Exception('Failed to search collection: $e');
    }
  }

  // Array operations
  Future<void> addToArray(String collection, String docId, String field, dynamic value) async {
    try {
      await _firestore.collection(collection).doc(docId).update({
        field: FieldValue.arrayUnion([value]),
      });
    } catch (e) {
      throw Exception('Failed to add to array: $e');
    }
  }

  Future<void> removeFromArray(String collection, String docId, String field, dynamic value) async {
    try {
      await _firestore.collection(collection).doc(docId).update({
        field: FieldValue.arrayRemove([value]),
      });
    } catch (e) {
      throw Exception('Failed to remove from array: $e');
    }
  }

  // Counter operations
  Future<void> incrementCounter(String collection, String docId, String field, int value) async {
    try {
      await _firestore.collection(collection).doc(docId).update({
        field: FieldValue.increment(value),
      });
    } catch (e) {
      throw Exception('Failed to increment counter: $e');
    }
  }

  // Timestamp operations
  Future<void> updateTimestamp(String collection, String docId, String field) async {
    try {
      await _firestore.collection(collection).doc(docId).update({
        field: FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update timestamp: $e');
    }
  }
}

enum BatchOperationType { set, update, delete }

class BatchOperation {
  final BatchOperationType type;
  final String collection;
  final String docId;
  final Map<String, dynamic>? data;

  BatchOperation({
    required this.type,
    required this.collection,
    required this.docId,
    this.data,
  });
}
