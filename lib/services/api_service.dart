import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_ecommerce_app/constants/app_constants.dart';
import 'package:flutter_ecommerce_app/models/product_model.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class ApiService {
  final http.Client client;

  ApiService({http.Client? client}) : client = client ?? http.Client();

  // 1. Fetch All Categories
  Future<List<String>> getCategories() async {
    final url = Uri.parse('${AppConstants.baseUrl}${AppConstants.categoriesEndpoint}');
    try {
      final response = await client.get(url).timeout(const Duration(seconds: 12));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => e.toString()).toList();
      } else {
        throw ApiException('Failed to load categories (Status: ${response.statusCode})');
      }
    } on SocketException {
      throw ApiException('No Internet connection. Please check your network.');
    } on http.ClientException {
      throw ApiException('Network request error. Please try again.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Unexpected error while fetching categories: $e');
    }
  }

  // 2. Fetch All Products
  Future<List<Product>> getAllProducts() async {
    final url = Uri.parse('${AppConstants.baseUrl}${AppConstants.productsEndpoint}');
    try {
      final response = await client.get(url).timeout(const Duration(seconds: 12));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw ApiException('Failed to load products (Status: ${response.statusCode})');
      }
    } on SocketException {
      throw ApiException('No Internet connection. Please check your network.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Unexpected error while fetching products: $e');
    }
  }

  // 3. Fetch Products By Category
  Future<List<Product>> getProductsByCategory(String category) async {
    final encodedCategory = Uri.encodeComponent(category);
    final url = Uri.parse(
      '${AppConstants.baseUrl}${AppConstants.categoryProductsEndpoint}/$encodedCategory',
    );
    try {
      final response = await client.get(url).timeout(const Duration(seconds: 12));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw ApiException('Failed to load category products (Status: ${response.statusCode})');
      }
    } on SocketException {
      throw ApiException('No Internet connection. Please check your network.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Unexpected error while fetching category products: $e');
    }
  }

  // 4. Fetch Product By ID (Task Specific Requirement)
  Future<Product> getProductById(int id) async {
    final url = Uri.parse('${AppConstants.baseUrl}${AppConstants.productsEndpoint}/$id');
    try {
      final response = await client.get(url).timeout(const Duration(seconds: 12));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return Product.fromJson(data);
      } else {
        throw ApiException('Product not found (Status: ${response.statusCode})');
      }
    } on SocketException {
      throw ApiException('No Internet connection. Please check your network.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Unexpected error while fetching product details: $e');
    }
  }
}
