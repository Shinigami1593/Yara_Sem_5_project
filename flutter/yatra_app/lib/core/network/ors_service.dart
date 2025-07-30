// lib/feature/home/data/service/ors_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yatra_app/feature/home/data/model/coordinate_model.dart';
import 'package:yatra_app/feature/home/data/model/route_model.dart';

class ORSService {
  static const String apiKey = '536b1aa1ad27498994308171ca7d0a55';
  static const String baseUrl = 'https://api.openrouteservice.org/v2/directions/driving-car';

  Future<RouteModel> fetchRouteFromORS({
    required String sourceName,
    required String destinationName,
    required List<double> sourceCoords,
    required List<double> destinationCoords,
  }) async {
    final body = jsonEncode({
      "coordinates": [sourceCoords, destinationCoords],
    });

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': apiKey,
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final coordinates = decoded['features'][0]['geometry']['coordinates'];

      final points = coordinates
          .map<CoordinateModel>((coord) => CoordinateModel(
                longitude: coord[0],
                latitude: coord[1],
              ))
          .toList();

      return RouteModel(
        id: 'ors-fallback',
        name: '$sourceName → $destinationName',
        source: sourceName,
        destination: destinationName,
        points: points,
        type: 'fallback',
        status: 'generated',
        userId: 'ors',
      );
    } else {
      throw Exception('ORS API failed: ${response.statusCode}');
    }
  }
}
