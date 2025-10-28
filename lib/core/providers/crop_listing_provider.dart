import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/crop_listing_model.dart';
import '../services/firestore_service.dart';
import '../constants/app_constants.dart';

final cropListingProvider = StateNotifierProvider<CropListingNotifier, CropListingState>((ref) {
  return CropListingNotifier(ref.read(firestoreServiceProvider));
});

final cropListingsProvider = Provider<List<CropListingModel>>((ref) {
  final state = ref.watch(cropListingProvider);
  return state.listings;
});

final cropListingLoadingProvider = Provider<bool>((ref) {
  final state = ref.watch(cropListingProvider);
  return state.isLoading;
});

final cropListingErrorProvider = Provider<String?>((ref) {
  final state = ref.watch(cropListingProvider);
  return state.error;
});

class CropListingState {
  final List<CropListingModel> listings;
  final bool isLoading;
  final String? error;
  final bool hasMore;
  final DocumentSnapshot? lastDocument;

  const CropListingState({
    this.listings = const [],
    this.isLoading = false,
    this.error,
    this.hasMore = true,
    this.lastDocument,
  });

  CropListingState copyWith({
    List<CropListingModel>? listings,
    bool? isLoading,
    String? error,
    bool? hasMore,
    DocumentSnapshot? lastDocument,
  }) {
    return CropListingState(
      listings: listings ?? this.listings,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      hasMore: hasMore ?? this.hasMore,
      lastDocument: lastDocument ?? this.lastDocument,
    );
  }
}

class CropListingNotifier extends StateNotifier<CropListingState> {
  final FirestoreService _firestoreService;

  CropListingNotifier(this._firestoreService) : super(const CropListingState()) {
    loadListings();
  }

  Future<void> loadListings({bool refresh = false}) async {
    if (refresh) {
      state = const CropListingState();
    }

    if (state.isLoading) return;

    try {
      state = state.copyWith(isLoading: true, error: null);

      final query = _firestoreService.getCollection(
        AppConstants.listingsCollection,
        query: FirebaseFirestore.instance
            .collection(AppConstants.listingsCollection)
            .where('status', isEqualTo: 'active')
            .orderBy('createdAt', descending: true),
        limit: AppConstants.defaultPageSize,
      );

      final snapshot = await query;
      final listings = snapshot.docs
          .map((doc) => CropListingModel.fromFirestore(doc))
          .toList();

      state = state.copyWith(
        listings: refresh ? listings : [...state.listings, ...listings],
        isLoading: false,
        hasMore: listings.length == AppConstants.defaultPageSize,
        lastDocument: snapshot.docs.isNotEmpty ? snapshot.docs.last : null,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> loadMoreListings() async {
    if (!state.hasMore || state.isLoading) return;

    try {
      state = state.copyWith(isLoading: true, error: null);

      final query = _firestoreService.getCollection(
        AppConstants.listingsCollection,
        query: FirebaseFirestore.instance
            .collection(AppConstants.listingsCollection)
            .where('status', isEqualTo: 'active')
            .orderBy('createdAt', descending: true)
            .startAfterDocument(state.lastDocument!),
        limit: AppConstants.defaultPageSize,
      );

      final snapshot = await query;
      final listings = snapshot.docs
          .map((doc) => CropListingModel.fromFirestore(doc))
          .toList();

      state = state.copyWith(
        listings: [...state.listings, ...listings],
        isLoading: false,
        hasMore: listings.length == AppConstants.defaultPageSize,
        lastDocument: snapshot.docs.isNotEmpty ? snapshot.docs.last : null,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> addListing(CropListingModel listing) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      await _firestoreService.setDocument(
        AppConstants.listingsCollection,
        listing.id,
        listing.toFirestore(),
      );

      state = state.copyWith(
        listings: [listing, ...state.listings],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> updateListing(CropListingModel listing) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      await _firestoreService.updateDocument(
        AppConstants.listingsCollection,
        listing.id,
        listing.toFirestore(),
      );

      final updatedListings = state.listings.map((l) {
        return l.id == listing.id ? listing : l;
      }).toList();

      state = state.copyWith(
        listings: updatedListings,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> deleteListing(String listingId) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      await _firestoreService.updateDocument(
        AppConstants.listingsCollection,
        listingId,
        {'status': 'cancelled', 'updatedAt': FieldValue.serverTimestamp()},
      );

      final updatedListings = state.listings
          .where((l) => l.id != listingId)
          .toList();

      state = state.copyWith(
        listings: updatedListings,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> searchListings(String query) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final snapshot = await _firestoreService.searchCollection(
        AppConstants.listingsCollection,
        'cropName',
        query,
        limit: AppConstants.defaultPageSize,
      );

      final listings = snapshot.docs
          .map((doc) => CropListingModel.fromFirestore(doc))
          .toList();

      state = state.copyWith(
        listings: listings,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> filterListings({
    String? cropCategory,
    String? state,
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      Query<Map<String, dynamic>> query = FirebaseFirestore.instance
          .collection(AppConstants.listingsCollection)
          .where('status', isEqualTo: 'active');

      if (cropCategory != null) {
        query = query.where('cropCategory', isEqualTo: cropCategory);
      }

      if (state != null) {
        query = query.where('state', isEqualTo: state);
      }

      if (minPrice != null) {
        query = query.where('pricePerUnit', isGreaterThanOrEqualTo: minPrice);
      }

      if (maxPrice != null) {
        query = query.where('pricePerUnit', isLessThanOrEqualTo: maxPrice);
      }

      query = query.orderBy('createdAt', descending: true);

      final snapshot = await query.limit(AppConstants.defaultPageSize).get();
      final listings = snapshot.docs
          .map((doc) => CropListingModel.fromFirestore(doc))
          .toList();

      state = state.copyWith(
        listings: listings,
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
