import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  final String baseUrl;
  // Mock QR scan endpoint - in production, this would be a real API endpoint
  final String mockQrEndpoint =
      'https://mocki.io/v1/d4867d8b-b5d5-4a48-a4ab-79131b5809b8';

  ApiService({required this.baseUrl});

  Future<Product?> getProductFromQr(String qrCode) async {
    try {
      // Parse the QR code URL to get the item ID
      final uri = Uri.parse(qrCode);
      final itemId = uri.queryParameters['item'];
      if (itemId == null) return null;

      // In a real app, you would make an API call here
      // For now, we'll simulate an API delay and return mock data
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock API response
      final mockProducts = {
        'snickers': Product(id: 'snickers', name: 'Snickers', price: 100),
        'lays': Product(id: 'lays', name: 'Lays Chips', price: 80),
        'coke': Product(id: 'coke', name: 'Coca-Cola', price: 120),
      };

      return mockProducts[itemId];
    } catch (e) {
      print('Error fetching product: $e');
      return null;
    }
  }

  Future<bool> logTransaction({
    required String email,
    required String itemId,
    required String itemName,
    required int quantity,
    required int totalPrice,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/log'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'itemId': itemId,
          'itemName': itemName,
          'quantity': quantity,
          'totalPrice': totalPrice,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getTransactions(String email) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/transactions?email=$email'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data);
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
