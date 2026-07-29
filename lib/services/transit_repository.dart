import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../models/transit_models.dart';

/// The single client-side gateway for Firebase. User-specific documents always
/// live below /users/{uid}; callers never provide a UID, preventing accidental
/// cross-user access in addition to the protection in Firebase rules.
class TransitRepository {
  TransitRepository({FirebaseFirestore? firestore, FirebaseAuth? auth, FirebaseDatabase? database})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance,
        _database = database ?? FirebaseDatabase.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final FirebaseDatabase _database;

  String get _uid => _auth.currentUser?.uid ?? (throw StateError('Sign in is required.'));
  DocumentReference<Map<String, dynamic>> get _user => _firestore.collection('users').doc(_uid);

  Future<void> createProfile({required String displayName, required String email}) => _user.set({
        'displayName': displayName,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'settings': {'smsFallbackEnabled': true},
      }, SetOptions(merge: true));

  Future<void> updateProfile({String? displayName, String? phoneNumber}) => _user.update({
        if (displayName != null) 'displayName': displayName,
        if (phoneNumber != null) 'phoneNumber': phoneNumber,
        'updatedAt': FieldValue.serverTimestamp(),
      });

  Stream<Map<String, dynamic>?> watchProfile() => _user.snapshots().map((snapshot) => snapshot.data());

  Future<void> setSmsFallback(bool enabled) => _user.set({
        'settings': {'smsFallbackEnabled': enabled},
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

  Stream<List<SavedStop>> watchSavedStops() => _user.collection('savedStops').orderBy('name').snapshots().map(
        (snapshot) => snapshot.docs.map((doc) => SavedStop.fromMap(doc.id, doc.data())).toList(),
      );
  Future<String> createSavedStop(SavedStop stop) async {
    final ref = _user.collection('savedStops').doc();
    await ref.set({...stop.toMap(), 'createdAt': FieldValue.serverTimestamp()});
    return ref.id;
  }
  Future<void> updateSavedStop(SavedStop stop) => _user.collection('savedStops').doc(stop.id).update(stop.toMap());
  Future<void> deleteSavedStop(String stopId) => _user.collection('savedStops').doc(stopId).delete();

  Stream<List<TripRequest>> watchTripRequests() => _user.collection('tripRequests').orderBy('createdAt', descending: true).snapshots().map(
        (snapshot) => snapshot.docs.map((doc) => TripRequest.fromMap(doc.id, doc.data())).toList(),
      );
  Future<String> createTripRequest({required String origin, required String destination, String? routeId}) async {
    final ref = _user.collection('tripRequests').doc();
    await ref.set(TripRequest(id: ref.id, origin: origin, destination: destination, status: 'requested', routeId: routeId).toMap()
      ..['createdAt'] = FieldValue.serverTimestamp());
    return ref.id;
  }
  Future<void> updateTripRequest(TripRequest request) => _user.collection('tripRequests').doc(request.id).update(request.toMap());
  Future<void> deleteTripRequest(String requestId) => _user.collection('tripRequests').doc(requestId).delete();

  Stream<QuerySnapshot<Map<String, dynamic>>> watchRoutes() => _firestore.collection('routes').snapshots();
  Stream<DocumentSnapshot<Map<String, dynamic>>> watchRoute(String routeId) => _firestore.collection('routes').doc(routeId).snapshots();
  // These methods are for dispatcher/admin clients. Firestore rules enforce the
  // staff claim; they cannot be used by ordinary riders.
  Future<String> createRoute(Map<String, dynamic> route) async {
    final ref = _firestore.collection('routes').doc();
    await ref.set({...route, 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()});
    return ref.id;
  }
  Future<void> updateRoute(String routeId, Map<String, dynamic> route) =>
      _firestore.collection('routes').doc(routeId).update({...route, 'updatedAt': FieldValue.serverTimestamp()});
  Future<void> deleteRoute(String routeId) => _firestore.collection('routes').doc(routeId).delete();

  Stream<DocumentSnapshot<Map<String, dynamic>>> watchBus(String busId) => _firestore.collection('buses').doc(busId).snapshots();
  Future<String> createBus(Map<String, dynamic> bus) async {
    final ref = _firestore.collection('buses').doc();
    await ref.set({...bus, 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()});
    return ref.id;
  }
  Future<void> updateBus(String busId, Map<String, dynamic> bus) =>
      _firestore.collection('buses').doc(busId).update({...bus, 'updatedAt': FieldValue.serverTimestamp()});
  Future<void> deleteBus(String busId) => _firestore.collection('buses').doc(busId).delete();
  Stream<BusLocation?> watchBusLocation(String busId) => _database.ref('busLocations/$busId').onValue.map((event) {
        final value = event.snapshot.value;
        return value is Map ? BusLocation.fromMap(value) : null;
      });
  Future<void> updateBusLocation(String busId, BusLocation location) => _database.ref('busLocations/$busId').set({
        'latitude': location.latitude,
        'longitude': location.longitude,
        'updatedAt': location.updatedAt,
      });

  Stream<QuerySnapshot<Map<String, dynamic>>> watchNotifications() =>
      _user.collection('notifications').orderBy('createdAt', descending: true).snapshots();
  Future<void> markNotificationRead(String id) => _user.collection('notifications').doc(id).update({'readAt': FieldValue.serverTimestamp()});
  Future<void> deleteNotification(String id) => _user.collection('notifications').doc(id).delete();
}
