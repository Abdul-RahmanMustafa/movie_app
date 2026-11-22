import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../movies/domain/entities/movie.dart';

enum WatchlistDataFailureType { unauthenticated, invalidData }

class WatchlistDataException implements Exception {
  const WatchlistDataException(this.type);

  final WatchlistDataFailureType type;
}

abstract interface class FirestoreWatchlistDataSource {
  Stream<List<Movie>> observeWatchlist();

  Stream<bool> observeSaved(int movieId);

  Future<bool> toggle(Movie movie);
}

class FirestoreWatchlistDataSourceImpl implements FirestoreWatchlistDataSource {
  FirestoreWatchlistDataSourceImpl({
    FirebaseFirestore? firestore,
    FirebaseAuth? firebaseAuth,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  CollectionReference<Map<String, dynamic>> _collection() {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) {
      throw const WatchlistDataException(
        WatchlistDataFailureType.unauthenticated,
      );
    }
    return _firestore.collection('users').doc(uid).collection('watchlist');
  }

  @override
  Stream<List<Movie>> observeWatchlist() {
    return _collection()
        .orderBy('savedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              List<Movie>.unmodifiable(snapshot.docs.map(_movieFromDocument)),
        );
  }

  @override
  Stream<bool> observeSaved(int movieId) {
    return _collection()
        .doc('$movieId')
        .snapshots()
        .map((snapshot) => snapshot.exists);
  }

  @override
  Future<bool> toggle(Movie movie) {
    final reference = _collection().doc('${movie.id}');
    return _firestore.runTransaction<bool>((transaction) async {
      final snapshot = await transaction.get(reference);
      if (snapshot.exists) {
        transaction.delete(reference);
        return false;
      }

      transaction.set(reference, {
        'movieId': movie.id,
        'title': movie.title,
        'posterUrl': _posterUrl(movie),
        'rating': movie.rating,
        'year': movie.year,
        'savedAt': FieldValue.serverTimestamp(),
      });
      return true;
    });
  }

  Movie _movieFromDocument(
    QueryDocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data();
    final movieId = _asInt(data['movieId']) ?? int.tryParse(document.id);
    final title = data['title'];
    if (movieId == null || movieId <= 0 || title is! String) {
      throw const WatchlistDataException(WatchlistDataFailureType.invalidData);
    }
    final posterUrl = data['posterUrl'] is String
        ? data['posterUrl'] as String
        : '';

    return Movie(
      id: movieId,
      title: title,
      year: _asInt(data['year']) ?? 0,
      rating: _asDouble(data['rating']) ?? 0,
      genres: const [],
      description: '',
      smallPosterUrl: posterUrl,
      mediumPosterUrl: posterUrl,
      largePosterUrl: posterUrl,
    );
  }
}

String _posterUrl(Movie movie) {
  if (movie.largePosterUrl.isNotEmpty) return movie.largePosterUrl;
  if (movie.mediumPosterUrl.isNotEmpty) return movie.mediumPosterUrl;
  return movie.smallPosterUrl;
}

int? _asInt(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse('$value');
}

double? _asDouble(Object? value) {
  if (value is num) return value.toDouble();
  return double.tryParse('$value');
}
