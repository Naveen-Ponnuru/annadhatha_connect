import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/group_model.dart';
import '../services/firestore_service.dart';
import '../constants/app_constants.dart';

final groupProvider = StateNotifierProvider<GroupNotifier, GroupState>((ref) {
  return GroupNotifier(ref.read(firestoreServiceProvider));
});

final groupsProvider = Provider<List<GroupModel>>((ref) {
  final state = ref.watch(groupProvider);
  return state.groups;
});

final groupLoadingProvider = Provider<bool>((ref) {
  final state = ref.watch(groupProvider);
  return state.isLoading;
});

final groupErrorProvider = Provider<String?>((ref) {
  final state = ref.watch(groupProvider);
  return state.error;
});

class GroupState {
  final List<GroupModel> groups;
  final bool isLoading;
  final String? error;
  final bool hasMore;
  final DocumentSnapshot? lastDocument;

  const GroupState({
    this.groups = const [],
    this.isLoading = false,
    this.error,
    this.hasMore = true,
    this.lastDocument,
  });

  GroupState copyWith({
    List<GroupModel>? groups,
    bool? isLoading,
    String? error,
    bool? hasMore,
    DocumentSnapshot? lastDocument,
  }) {
    return GroupState(
      groups: groups ?? this.groups,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      hasMore: hasMore ?? this.hasMore,
      lastDocument: lastDocument ?? this.lastDocument,
    );
  }
}

class GroupNotifier extends StateNotifier<GroupState> {
  final FirestoreService _firestoreService;

  GroupNotifier(this._firestoreService) : super(const GroupState()) {
    loadGroups();
  }

  Future<void> loadGroups({bool refresh = false}) async {
    if (refresh) {
      state = const GroupState();
    }

    if (state.isLoading) return;

    try {
      state = state.copyWith(isLoading: true, error: null);

      final query = _firestoreService.getCollection(
        AppConstants.groupsCollection,
        query: FirebaseFirestore.instance
            .collection(AppConstants.groupsCollection)
            .where('status', isEqualTo: 'active')
            .orderBy('createdAt', descending: true),
        limit: AppConstants.defaultPageSize,
      );

      final snapshot = await query;
      final groups = snapshot.docs
          .map((doc) => GroupModel.fromFirestore(doc))
          .toList();

      state = state.copyWith(
        groups: refresh ? groups : [...state.groups, ...groups],
        isLoading: false,
        hasMore: groups.length == AppConstants.defaultPageSize,
        lastDocument: snapshot.docs.isNotEmpty ? snapshot.docs.last : null,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> loadMoreGroups() async {
    if (!state.hasMore || state.isLoading) return;

    try {
      state = state.copyWith(isLoading: true, error: null);

      final query = _firestoreService.getCollection(
        AppConstants.groupsCollection,
        query: FirebaseFirestore.instance
            .collection(AppConstants.groupsCollection)
            .where('status', isEqualTo: 'active')
            .orderBy('createdAt', descending: true)
            .startAfterDocument(state.lastDocument!),
        limit: AppConstants.defaultPageSize,
      );

      final snapshot = await query;
      final groups = snapshot.docs
          .map((doc) => GroupModel.fromFirestore(doc))
          .toList();

      state = state.copyWith(
        groups: [...state.groups, ...groups],
        isLoading: false,
        hasMore: groups.length == AppConstants.defaultPageSize,
        lastDocument: snapshot.docs.isNotEmpty ? snapshot.docs.last : null,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> createGroup(GroupModel group) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      await _firestoreService.setDocument(
        AppConstants.groupsCollection,
        group.id,
        group.toFirestore(),
      );

      state = state.copyWith(
        groups: [group, ...state.groups],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> updateGroup(GroupModel group) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      await _firestoreService.updateDocument(
        AppConstants.groupsCollection,
        group.id,
        group.toFirestore(),
      );

      final updatedGroups = state.groups.map((g) {
        return g.id == group.id ? group : g;
      }).toList();

      state = state.copyWith(
        groups: updatedGroups,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> joinGroup(String groupId, String farmerId) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      await _firestoreService.addToArray(
        AppConstants.groupsCollection,
        groupId,
        'farmerIds',
        farmerId,
      );

      // Update local state
      final updatedGroups = state.groups.map((group) {
        if (group.id == groupId) {
          return group.copyWith(
            farmerIds: [...group.farmerIds, farmerId],
            farmerCount: group.farmerCount + 1,
          );
        }
        return group;
      }).toList();

      state = state.copyWith(
        groups: updatedGroups,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> leaveGroup(String groupId, String farmerId) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      await _firestoreService.removeFromArray(
        AppConstants.groupsCollection,
        groupId,
        'farmerIds',
        farmerId,
      );

      // Update local state
      final updatedGroups = state.groups.map((group) {
        if (group.id == groupId) {
          return group.copyWith(
            farmerIds: group.farmerIds.where((id) => id != farmerId).toList(),
            farmerCount: group.farmerCount - 1,
          );
        }
        return group;
      }).toList();

      state = state.copyWith(
        groups: updatedGroups,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> searchGroups(String query) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final snapshot = await _firestoreService.searchCollection(
        AppConstants.groupsCollection,
        'cropName',
        query,
        limit: AppConstants.defaultPageSize,
      );

      final groups = snapshot.docs
          .map((doc) => GroupModel.fromFirestore(doc))
          .toList();

      state = state.copyWith(
        groups: groups,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> filterGroups({
    String? cropCategory,
    String? state,
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      Query<Map<String, dynamic>> query = FirebaseFirestore.instance
          .collection(AppConstants.groupsCollection)
          .where('status', isEqualTo: 'active');

      if (cropCategory != null) {
        query = query.where('cropCategory', isEqualTo: cropCategory);
      }

      if (state != null) {
        query = query.where('state', isEqualTo: state);
      }

      if (minPrice != null) {
        query = query.where('minPrice', isGreaterThanOrEqualTo: minPrice);
      }

      if (maxPrice != null) {
        query = query.where('maxPrice', isLessThanOrEqualTo: maxPrice);
      }

      query = query.orderBy('createdAt', descending: true);

      final snapshot = await query.limit(AppConstants.defaultPageSize).get();
      final groups = snapshot.docs
          .map((doc) => GroupModel.fromFirestore(doc))
          .toList();

      state = state.copyWith(
        groups: groups,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
