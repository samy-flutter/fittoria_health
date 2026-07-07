import 'package:dio/dio.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_exceptions.dart';
import '../models/shop_models.dart';

abstract class ShopRemoteDataSource {
  Future<ShopData> getShopData({
    String? query,
    String? categoryId,
    bool? recommended,
    bool? picks,
  });
  Future<void> addToCart(int productId, int qty);
  Future<Map<String, dynamic>> getCart();
  Future<void> updateCartItemQty(int cartItemId, int qty);
  Future<void> removeCartItem(int cartItemId);
  Future<Map<String, dynamic>> checkout(Map<String, dynamic> shippingDetails);
  Future<List<Map<String, dynamic>>> getOrders();
  Future<Map<String, dynamic>> getOrderDetails(int orderId);
  Future<Map<String, dynamic>> verifyCashfreePayment(int orderId);

  Future<List<ShopAddress>> getAddresses();
  Future<void> addAddress(ShopAddress address);
  Future<void> updateAddress(ShopAddress address);
  Future<void> deleteAddress(int addressId);
}

class ShopRemoteDataSourceImpl implements ShopRemoteDataSource {
  final DioClient dioClient;

  ShopRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<ShopData> getShopData({
    String? query,
    String? categoryId,
    bool? recommended,
    bool? picks,
  }) async {
    try {
      final response = await dioClient.get(
        ApiEndpoints.patientShop,
        queryParameters: {
          if (query != null && query.isNotEmpty) 'q': query,
          if (categoryId != null && categoryId.isNotEmpty)
            'category': categoryId,
          if (recommended == true) 'recommended': 'true',
          if (picks == true) 'picks': 'true',
        },
      );

      final products = (response.data['products'] as List)
          .map((e) => ShopProduct.fromJson(e))
          .toList();
      final categories = (response.data['categories'] as List)
          .map((e) => ShopCategory.fromJson(e))
          .toList();
      final goalTags = response.data['goal_tags'] != null
          ? List<String>.from(response.data['goal_tags'])
          : null;

      return ShopData(
        products: products,
        categories: categories,
        goalTags: goalTags,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  @override
  Future<void> addToCart(int productId, int qty) async {
    try {
      await dioClient.post(
        ApiEndpoints.patientCart,
        data: {'product_id': productId, 'qty': qty},
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> getCart() async {
    try {
      final response = await dioClient.get(ApiEndpoints.patientCart);
      final items = (response.data['items'] as List)
          .map((e) => CartItem.fromJson(e))
          .toList();
      final total = (response.data['total'] as num).toDouble();
      return {'items': items, 'total': total};
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  @override
  Future<void> updateCartItemQty(int cartItemId, int qty) async {
    try {
      await dioClient.patch(
        ApiEndpoints.patientCart,
        data: {'cart_item_id': cartItemId, 'qty': qty},
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  @override
  Future<void> removeCartItem(int cartItemId) async {
    try {
      await dioClient.delete(
        ApiEndpoints.patientCart,
        data: {'cart_item_id': cartItemId},
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> checkout(
    Map<String, dynamic> shippingDetails,
  ) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.patientOrders,
        data: shippingDetails,
      );
      return response.data;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getOrders() async {
    try {
      final response = await dioClient.get(ApiEndpoints.patientOrders);
      return List<Map<String, dynamic>>.from(response.data['orders']);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> getOrderDetails(int orderId) async {
    try {
      final response = await dioClient.get(ApiEndpoints.patientOrderDetails(orderId));
      return response.data;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> verifyCashfreePayment(int orderId) async {
    try {
      final response = await dioClient.post('${ApiEndpoints.patientOrders}/$orderId/verify');
      return response.data;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  @override
  Future<List<ShopAddress>> getAddresses() async {
    try {
      final response = await dioClient.get(ApiEndpoints.patientAddresses);
      final addresses = (response.data['addresses'] as List?)?.map((e) => ShopAddress.fromJson(e)).toList() ?? [];
      return addresses;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  @override
  Future<void> addAddress(ShopAddress address) async {
    try {
      await dioClient.post(ApiEndpoints.patientAddresses, data: address.toJson());
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  @override
  Future<void> updateAddress(ShopAddress address) async {
    try {
      final data = address.toJson();
      await dioClient.patch('${ApiEndpoints.patientAddresses}/${address.id}', data: data);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  @override
  Future<void> deleteAddress(int addressId) async {
    try {
      await dioClient.delete('${ApiEndpoints.patientAddresses}/$addressId');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }
}
