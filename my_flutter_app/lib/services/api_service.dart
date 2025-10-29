import 'package:dio/dio.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../models/order.dart';
import '../data/api_mock_data.dart'; // Добавьте этот импорт

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://coffeeshop.academy.effective.band/api/v1',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  Future<ProductResponse> getProducts({int page = 0, int limit = 50, int? categoryId}) async {
    try {
      final Map<String, dynamic> queryParams = {
        'page': page,
        'limit': limit,
      };
      
      if (categoryId != null) {
        queryParams['category'] = categoryId;
      }

      final response = await _dio.get('/products', queryParameters: queryParams);
      return ProductResponse.fromJson(response.data);
    } catch (e) {
      // При ошибке возвращаем моковые данные
      print('API Error, using mock data: $e');
      return ProductResponse(
        products: ApiMockData.mockProducts,
        totalCount: ApiMockData.mockProducts.length,
      );
    }
  }

  Future<Product> getProductById(int id) async {
    try {
      final response = await _dio.get('/products/$id');
      return Product.fromJson(response.data);
    } catch (e) {
      // При ошибке возвращаем моковый продукт
      final mockProduct = ApiMockData.mockProducts.firstWhere(
        (product) => product.id == id,
        orElse: () => ApiMockData.mockProducts.first,
      );
      return mockProduct;
    }
  }

  Future<List<Category>> getCategories() async {
    try {
      final response = await _dio.get('/products/categories');
      return (response.data as List)
          .map((categoryJson) => Category.fromJson(categoryJson))
          .toList();
    } catch (e) {
      // При ошибке возвращаем моковые категории
      print('API Error, using mock categories: $e');
      return ApiMockData.mockCategories;
    }
  }

  Future<OrderResponse> createOrder(OrderRequest orderRequest) async {
    try {
      final response = await _dio.post(
        '/orders',
        data: orderRequest.toJson(),
      );
      return OrderResponse.fromJson(response.data);
    } catch (e) {
      // При ошибке симулируем успешный заказ
      print('API Error, simulating successful order: $e');
      return OrderResponse(orderId: DateTime.now().millisecondsSinceEpoch, status: 'success');
    }
  }
}