import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/shop_models.dart';

abstract class ShopRepository {
  Future<Either<Failure, ShopData>> getShopData({
    String? query,
    String? categoryId,
    bool? recommended,
    bool? picks,
  });
  
  Future<Either<Failure, void>> addToCart(int productId, int qty);
  Future<Either<Failure, Map<String, dynamic>>> getCart();
  Future<Either<Failure, void>> updateCartItemQty(int cartItemId, int qty);
  Future<Either<Failure, void>> removeCartItem(int cartItemId);
  Future<Either<Failure, Map<String, dynamic>>> checkout(Map<String, dynamic> shippingDetails);
  Future<Either<Failure, List<Map<String, dynamic>>>> getOrders();
  Future<Either<Failure, ShopOrderDetail>> getOrderDetails(int orderId);
  Future<Either<Failure, Map<String, dynamic>>> verifyCashfreePayment(int orderId);

  Future<Either<Failure, List<ShopAddress>>> getAddresses();
  Future<Either<Failure, void>> addAddress(ShopAddress address);
  Future<Either<Failure, void>> updateAddress(ShopAddress address);
  Future<Either<Failure, void>> deleteAddress(int addressId);
}
