import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_keys.dart';

class PlaceSuggestion {
  final String text;
  final String placeId;
  const PlaceSuggestion({required this.text, required this.placeId});
}

/// Places Autocomplete (New) via the RapidAPI proxy, biased to the Kigali
/// metro area. Falls back to an empty list on any error (network, quota,
/// missing key) so the destination picker's manual "Use '$query'" option
/// still works even if this call fails.
class PlacesAutocompleteService {
  static const _endpoint = 'https://google-map-places-new-v2.p.rapidapi.com/v1/places:autocomplete';
  static const _kigaliLat = -1.9441;
  static const _kigaliLng = 30.0619;
  static const _biasRadiusMeters = 20000;

  Future<List<PlaceSuggestion>> search(String input) async {
    if (input.trim().isEmpty || rapidApiPlacesKey.isEmpty) return const [];

    try {
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-FieldMask': '*',
          'x-rapidapi-host': 'google-map-places-new-v2.p.rapidapi.com',
          'x-rapidapi-key': rapidApiPlacesKey,
        },
        body: jsonEncode({
          'input': input,
          'locationBias': {
            'circle': {
              'center': {'latitude': _kigaliLat, 'longitude': _kigaliLng},
              'radius': _biasRadiusMeters,
            },
          },
          'regionCode': 'RW',
          'languageCode': 'en',
          'includeQueryPredictions': true,
        }),
      ).timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) return const [];

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final suggestions = body['suggestions'] as List? ?? const [];
      return suggestions
          .map((s) => (s as Map<String, dynamic>)['placePrediction'] as Map<String, dynamic>?)
          .whereType<Map<String, dynamic>>()
          .map((prediction) => PlaceSuggestion(
                text: ((prediction['text'] as Map<String, dynamic>?)?['text'] as String?) ?? '',
                placeId: prediction['placeId'] as String? ?? '',
              ))
          .where((suggestion) => suggestion.text.isNotEmpty)
          .toList();
    } catch (_) {
      return const [];
    }
  }
}
