import 'package:cloud_firestore/cloud_firestore.dart';

class SavedStop {
  const SavedStop({required this.id, required this.name, required this.latitude, required this.longitude, this.note});
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String? note;

  Map<String, dynamic> toMap() => {
        'name': name,
        'latitude': latitude,
        'longitude': longitude,
        if (note != null) 'note': note,
        'updatedAt': FieldValue.serverTimestamp(),
      };

  factory SavedStop.fromMap(String id, Map<String, dynamic> data) => SavedStop(
        id: id,
        name: data['name'] as String? ?? '',
        latitude: (data['latitude'] as num?)?.toDouble() ?? 0,
        longitude: (data['longitude'] as num?)?.toDouble() ?? 0,
        note: data['note'] as String?,
      );
}

class TripRequest {
  const TripRequest({required this.id, required this.origin, required this.destination, required this.status, this.routeId});
  final String id;
  final String origin;
  final String destination;
  final String status;
  final String? routeId;

  Map<String, dynamic> toMap() => {
        'origin': origin,
        'destination': destination,
        'status': status,
        if (routeId != null) 'routeId': routeId,
        'updatedAt': FieldValue.serverTimestamp(),
      };

  factory TripRequest.fromMap(String id, Map<String, dynamic> data) => TripRequest(
        id: id,
        origin: data['origin'] as String? ?? '',
        destination: data['destination'] as String? ?? '',
        status: data['status'] as String? ?? 'requested',
        routeId: data['routeId'] as String?,
      );
}

class BusLocation {
  const BusLocation({required this.latitude, required this.longitude, required this.updatedAt});
  final double latitude;
  final double longitude;
  final int updatedAt;

  factory BusLocation.fromMap(Map<dynamic, dynamic> data) => BusLocation(
        latitude: (data['latitude'] as num?)?.toDouble() ?? 0,
        longitude: (data['longitude'] as num?)?.toDouble() ?? 0,
        updatedAt: (data['updatedAt'] as num?)?.toInt() ?? 0,
      );
}
