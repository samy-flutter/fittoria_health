import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../../core/logging/app_logger.dart';

class GooglePlacesService {
  final Dio _dio = Dio();
  String get _apiKey => dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

  Future<List<Map<String, dynamic>>> getSuggestions(String input) async {
    if (input.isEmpty) return [];
    try {
      final response = await _dio.get(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json',
        queryParameters: {
          'input': input,
          'key': _apiKey,
          'components': 'country:in', // Restrict to India
        },
      );
      if (response.data['status'] == 'OK') {
        return List<Map<String, dynamic>>.from(response.data['predictions']);
      } else {
        AppLogger.e('Google Places API Error: ${response.data}');
      }
    } catch (e) {
      AppLogger.e('Error fetching suggestions: $e');
    }
    return [];
  }

  Future<Map<String, String>?> getPlaceDetails(String placeId) async {
    try {
      final response = await _dio.get(
        'https://maps.googleapis.com/maps/api/place/details/json',
        queryParameters: {
          'place_id': placeId,
          'key': _apiKey,
          'fields': 'address_components,formatted_address,name',
        },
      );

      if (response.data['status'] == 'OK') {
        final result = response.data['result'];
        final components = result['address_components'] as List;

        String city = '';
        String state = '';
        String pincode = '';
        String streetNumber = '';
        String route = '';
        String neighborhood = '';
        String fallbackName = result['name'] ?? '';

        for (var component in components) {
          final types = component['types'] as List;
          if (types.contains('locality')) {
            city = component['long_name'];
          } else if (types.contains('administrative_area_level_2') && city.isEmpty) {
            city = component['long_name'];
          } else if (types.contains('administrative_area_level_1')) {
            state = component['long_name'];
          } else if (types.contains('postal_code')) {
            pincode = component['long_name'];
          } else if (types.contains('street_number')) {
            streetNumber = component['long_name'];
          } else if (types.contains('route')) {
            route = component['long_name'];
          } else if (types.contains('neighborhood') || types.contains('sublocality') || types.contains('sublocality_level_1')) {
            neighborhood = component['long_name'];
          }
        }

        String address1 = [streetNumber, route, neighborhood].where((e) => e.isNotEmpty).join(', ');
        if (address1.isEmpty) {
          address1 = fallbackName;
        }

        return {
          'addressLine1': address1,
          'city': city,
          'state': state,
          'pincode': pincode,
        };
      }
    } catch (e) {
      AppLogger.e('Error fetching place details: $e');
    }
    return null;
  }
}
