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
}
